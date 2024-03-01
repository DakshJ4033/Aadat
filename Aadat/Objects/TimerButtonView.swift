//
//  TimerButtonView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData

struct TimerButtonView: View {
    @Environment(\.modelContext) var context
    @State var taskStarted = false
    let taskTag: String
    @Query private var sessions: [Session]
    
    var body: some View {
        
        Button {
            if let mostRecentSession = sessions.last {
                if mostRecentSession.endTime == nil {
                    // if we have a session, and its endTime is nil, end the session
                    mostRecentSession.endSession()
                    taskStarted = false
                }
                else {
                    // if we have a session, but its endTime is not nil, then make a new session
                    let newSession = Session(startTime: Date.now)
                    newSession.tag = taskTag
                    context.insert(newSession)
                    taskStarted = true
                }
            } else {
                // if we have no sessions created, just create a new one
                let newSession = Session(startTime: Date.now)
                newSession.tag = taskTag
                context.insert(newSession)
                taskStarted = true
            }
        } label: {
            Image(systemName: taskStarted ? "stop.circle.fill" : "play.circle.fill")
                .resizable() // Make the image resizable
                .frame(width: 24, height: 24)
                .foregroundColor(taskStarted ? .red : .blue)
        }
        .padding()
    }
}

#Preview {
    TimerButtonView(taskTag: "")
}
