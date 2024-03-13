//
//  SessionDetailedView.swift
//  Aadat
//
//  Created by Sauvikesh Lal on 2/19/24.
//

import SwiftUI

struct SessionDetailedView: View {
    var session: Session
    @Binding var showSessionPopover: Bool
    
    @Environment(\.modelContext) var context
    @State var userStartTime : Date = Date()
    @State var userEndTime : Date = Date()
    @State private var onGoingTask: Bool = false
    
    var body: some View {
        VStack {
            DatePicker("Start Time:", selection: $userStartTime, displayedComponents: [.date, .hourAndMinute])
                .padding(10)
                .standardText()
                .datePickerStyle(.compact)
                .tint(Color(hex: standardBrightPinkHex))
                .environment(\.colorScheme, .dark) // <- This modifier

            DatePicker("End Time:", selection: $userEndTime, displayedComponents: [.date, .hourAndMinute])
                .padding(10)
                .opacity(onGoingTask ? 0:1)
                .standardText()
                .datePickerStyle(.compact)
                .tint(Color(hex: standardBrightPinkHex))
                .environment(\.colorScheme, .dark) // <- This modifier

            Toggle("Ongoing session?", isOn: $onGoingTask)
                .padding(10)
                .standardText()
            HStack {
                Spacer()
                Button {
                    context.delete(session)
                } label: {
                    Label("Delete", systemImage: "trash")
                        .foregroundStyle(Color(hex: standardLightHex))
                        .bold()
                }
                .buttonStyle(.bordered)
                .background(Color(.red))
                .cornerRadius(5)
                .controlSize(.large)
            
                Spacer()

                Button {
                    session.startTime = userStartTime
                    
                    if !onGoingTask {
                        session.endTime = userEndTime
                    } else {
                        session.endTime = nil
                    }
                    
                    showSessionPopover = false
                } label: {
                    Label("Save", systemImage: "clock")
                        .foregroundStyle(Color(hex: standardLightHex))
                        .bold()
                }
                .buttonStyle(.bordered)
                .background(Color(hex: standardDarkHex))
                .cornerRadius(5)
                .controlSize(.large)
                .onAppear {
                    userStartTime = session.startTime
                    userEndTime = session.endTime ?? Date()
                }

                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
}

