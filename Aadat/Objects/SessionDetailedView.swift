//
//  SessionDetailedView.swift
//  Aadat
//
//  Created by Sauvikesh Lal on 2/19/24.
//

import SwiftUI

struct SessionDetailedView: View {
    var session: Session
    
    @State var userStartTime : Date = Date()
    @State var userEndTime : Date = Date()
    @State private var onGoingTask: Bool = false
    
    var body: some View {
        VStack {
                DatePicker("Add a start time", selection: $userStartTime, displayedComponents: .hourAndMinute)
                .padding(20)
            
                DatePicker("Add an end time", selection: $userEndTime, displayedComponents: .hourAndMinute)
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
            }
            label: {
                Label("Log Time", systemImage: "clock")
                   .foregroundColor(.black)
           }
            .buttonStyle(.bordered)
            .background(.blue)
            .cornerRadius(5)
            .controlSize(.large)
        }
    }
    
}

#Preview {
    SessionDetailedView(session: Session(startTime: Date.now))
}
