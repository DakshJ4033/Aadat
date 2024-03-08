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
    let taskTag: String
    @Query private var sessions: [Session]
    
    
    /* Live Activity vars */
    @State private var isTrackingTime: Bool = false
    @State private var startTime: Date? = nil
    @State private var activity: Activity<TimerWidgetAttributes>? = nil
    
    var body: some View {
        
        Button {
            /* Start Live Activity */
            isTrackingTime.toggle()
            if isTrackingTime {
                startTime = .now
                let attributes = TimerWidgetAttributes(name: "name here")
                let state = TimerWidgetAttributes.ContentState(emoji: "emoji")
                activity = try? Activity.request(
                    attributes: attributes,
                    content: .init(state: state, staleDate: nil), 
                    pushType: nil)
            } else {
                guard let startTime else {return}
                let state = TimerWidgetAttributes.ContentState(emoji: "emoji") // use startTime when you add it to the dynamic data / attributes?
                _Concurrency.Task {
                    await activity?.end(_:.init(state: state, staleDate: nil), dismissalPolicy: .immediate)
                }
                self.startTime = nil
            }
            
            
            /* Other stuff */
            if let mostRecentSession = retrieveMostRecentSession(taskTag: taskTag, sessions: sessions) {
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
        .onAppear {
            if let mostRecentSession = retrieveMostRecentSession(taskTag: taskTag, sessions: sessions) {
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

func retrieveMostRecentSession(taskTag: String, sessions: [Session]) -> Session? {
    for session in sessions.reversed() {
        if session.tag == taskTag {
            return session
        }
    }
    return nil
}

#Preview {
    TimerButtonView(taskTag: "")
}
