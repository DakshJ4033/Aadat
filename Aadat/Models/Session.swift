//
//  Session.swift
//  Aadat
//
//  Created by Daksh Jain on 2/22/24.
//

import Foundation
import SwiftData

@Model
final class Session {
    var startTime: Date
    var endTime: Date?
    
    init(startTime: Date, endTime: Date? = nil) {
        self.startTime = startTime
        self.endTime = endTime
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
