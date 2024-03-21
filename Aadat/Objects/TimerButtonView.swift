//
//  TimerButtonView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData
import ActivityKit

struct TimerButtonView: View {
    @Environment(\.modelContext) var context
    @Query private var sessions: [Session]
    @State var taskStarted = false
    let task: Task
    
    fileprivate func createSession() {
        let newSession = Session(startTime: Date.now)
        newSession.color = task.color
        newSession.tag = task.tag
        context.insert(newSession)
        taskStarted = true
    }
    
    fileprivate func retrieveMostRecentSession(task: Task, sessions: [Session]) -> Session? {
        for session in sessions.reversed() {
            if session.tag == task.tag {
                return session
            }
        }
        return nil
    }

    var body: some View {
        Button {
            /* Manage session creation and stops */
            if let mostRecentSession = retrieveMostRecentSession(task: task, sessions: sessions) {
                if mostRecentSession.endTime == nil {
                    // if we have a session, and its endTime is nil, end the session
                    mostRecentSession.endSession()
                    taskStarted = false
                }
                else {
                    // if we have a session, but its endTime is not nil, then make a new session
                    createSession()
                }
            } else {
                // if we have no sessions created, just create a new one
                createSession()
            }
        } label: {
            Image(systemName: taskStarted ? "stop.circle.fill" : "play.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(taskStarted ? Color(hex:standardLightRedHex) : Color(hex:standardBrightPinkHex))
        }
        .padding()
        .onAppear {
            if let mostRecentSession = retrieveMostRecentSession(task: task, sessions: sessions) {
                if mostRecentSession.endTime == nil {
                    taskStarted = true
                }
                else {
                    taskStarted = false
                }
            }
        }
    }
}

#Preview {
    TimerButtonView(task: Task())
}
