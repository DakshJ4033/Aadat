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
    var tag: String
    var isAutomatic: Bool = false
    
    init(startTime: Date, endTime: Date? = nil, tag: String = "No Tag") {
        self.startTime = startTime
        self.endTime = endTime
        self.tag = tag
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
        
        guard let formattedString = formatter.string(from: self.totalTime())
        else {
            return ""
        }
        return formattedString
    }
}
