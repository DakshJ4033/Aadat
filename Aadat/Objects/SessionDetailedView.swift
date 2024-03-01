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
                DatePicker("Add a start time", selection: $userStartTime, displayedComponents: [.date, .hourAndMinute])
                .padding(20)
            
                DatePicker("Add an end time", selection: $userEndTime, displayedComponents: [.date, .hourAndMinute])
                    .padding(20)
                    .opacity(onGoingTask ? 0:1)
            
            Toggle("Ongoing task?", isOn: $onGoingTask)
                .padding(20)
            
            Button {
                session.startTime = userStartTime
                
                if !onGoingTask {
                    session.endTime = userEndTime
                } else {
                    session.endTime = nil
                }
                
                showSessionPopover = false
            }
            label: {
                Label("Log Time", systemImage: "clock")
                   .foregroundColor(.black)
           }
            .buttonStyle(.bordered)
            .background(.blue)
            .cornerRadius(5)
            .controlSize(.large)
            
            
            Button {
                context.delete(session)
            }
            label: {
                Label("Delete Session", systemImage: "trash")
                   .foregroundColor(.black)
           }
            
            .buttonStyle(.bordered)
            .background(.red)
            .cornerRadius(5)
            .controlSize(.large)
        }
    }
    
}

