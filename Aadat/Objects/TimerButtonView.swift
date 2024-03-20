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
    @State var taskStarted = false
    let task: Task
    @Query private var sessions: [Session]
    
    
    /* Live Activity vars */
    @State private var isTrackingTime: Bool = false
    @State private var startTime: Date? = nil
    
    var body: some View {
        
        Button {
            /* Start Live Activity */
            isTrackingTime.toggle()
            if isTrackingTime {
                startTime = .now
            } else {
                guard startTime != nil else {return}
                self.startTime = nil
            }
            
            
            /* Other stuff */
            if let mostRecentSession = retrieveMostRecentSession(task: task, sessions: sessions) {
                if mostRecentSession.endTime == nil {
                    // if we have a session, and its endTime is nil, end the session
                    mostRecentSession.endSession()
                    taskStarted = false
                }
                else {
                    // if we have a session, but its endTime is not nil, then make a new session
                    let newSession = Session(startTime: Date.now)
                    newSession.color = task.color
                    newSession.tag = task.tag
                    context.insert(newSession)
                    taskStarted = true
                }
            } else {
                // if we have no sessions created, just create a new one
                let newSession = Session(startTime: Date.now)
                newSession.color = task.color
                newSession.tag = task.tag
                context.insert(newSession)
                taskStarted = true
            }
        } label: {
            Image(systemName: taskStarted ? "stop.circle.fill" : "play.circle.fill")
                .resizable() // Make the image resizable
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

func retrieveMostRecentSession(task: Task, sessions: [Session]) -> Session? {
    for session in sessions.reversed() {
        if session.tag == task.tag {
            return session
        }
    }
    return nil
}

#Preview {
    TimerButtonView(task: Task())
}
