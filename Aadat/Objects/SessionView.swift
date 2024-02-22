//
//  SessionView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

/* Session Class Dec. */
class Session {
    var taskName: String
    var startTime: Date
    var endTime: Date?
    var task: Task?
    
    // create a session for the task you want to work on
    // constructor automatically adds the start time on creation
    init(taskName: String = "default") {
            self.taskName = taskName
            self.startTime = Date()
        }
    
    func totalTime() -> TimeInterval {
            return (endTime ?? Date()).timeIntervalSince(startTime)
    }
    
    func endSession() {
        self.endTime = Date()
    }
    
    
    // user friendly formatted time getters
    func getStartTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self.startTime)
    }
    
    func getEndTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self.endTime ?? Date())
    }
    
    func getTotalTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        return formatter.string(from: self.totalTime())!
    }
}

struct SessionView: View {
    var session: Session
    
    @State private var showAccountsPopOver: Bool = false
    var body: some View {
        HStack {
            Text("\(session.taskName)")
                .lineLimit(1)
            Text("Started: \(session.getStartTime())")
        }
        .padding()
        .background(.gray)
        .onTapGesture {
                            showAccountsPopOver = true;
                        }
                        .popover(isPresented: $showAccountsPopOver) {
                            SessionDetailedView(session: session)
                        }
    }
}

#Preview {
    SessionView(session: Session(taskName: "Homework"))
}
