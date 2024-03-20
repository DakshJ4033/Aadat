//
//  ChartView.swift
//  Aadat
//
//  Created by Ako Tako on 2/27/24.
//

import Foundation
import SwiftUI
import SwiftData
import Charts

struct SessionGroupKey: Hashable {
    var startTime: Date
    var tag: String
    var color: Color
}

struct SessionData: Identifiable {
    var id = UUID()
    var tag: String
    var color: Color
    var dayOfWeek: Date
    var totalTime: TimeInterval
}

struct DailyTimeData: Identifiable {
    let id: String // Use the date as the unique identifier
    let timeInterval: TimeInterval
    
    init(date: String, interval: TimeInterval) {
        self.id = date
        self.timeInterval = interval
    }
}

struct ChartView: View {
    @Query private var tasks: [Task]
    @Query private var sessions: [Session]
    @State private var groupedData: [(tag: String, data: [(weekday: Date, totalTime: TimeInterval)])] = []
    
    var body: some View {
        let groupedSessions = groupSessionsByTag(sessions: sessions)
        let dailyTimeData2: [DailyTimeData] = groupSessionsByTag(sessions: sessions).map { date, interval in
            DailyTimeData(date: date, interval: interval)
        }
        
        Chart(dailyTimeData2) { dataPoint in
            SectorMark(
                angle: .value(
                    Text(verbatim: dataPoint.id),
                    dataPoint.timeInterval
                ),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .cornerRadius(5)
            .foregroundStyle(
                by: .value(
                    "Type", dataPoint.id
                )
            )
        }
        .chartBackground { chartProxy in
          GeometryReader { geometry in
            if let plotFrame = chartProxy.plotFrame {
              let frame = geometry[plotFrame]
              VStack {
                Text("Top Task")
                  .font(.callout)
                  .foregroundStyle(.secondary)
                Text(groupedSessions.max(by: { $0.value < $1.value })?.key ?? "")
                  .font(.title2.bold())
                  .foregroundColor(.primary)
              }
              .position(x: frame.midX, y: frame.midY)
            } else {
              // Handle the case where plotFrame is nil (optional chaining can be used here)
              Text("No frame available")
            }
          }
        }
        .frame(height: 250)
        .padding(15)
        .background(Color(hex: standardLightHex))
        .cornerRadius(5)
        
        // view that shows if you have a streak of consecutive sessions for a tag going
        VStack {
            Text("🔥Habit Streaks🔥 ")
                .standardTitleText()
            Section {
                ScrollView {
                    ForEach(dailyTimeData2) { tag in
                        let currentStreak = calculateStreak(for: sessions, withTag: tag.id)
                        
                        if currentStreak == 1 {
                            VStack {
                                Text("\(tag.id): \(currentStreak) day")
                                    .foregroundColor(.white)
                            }
                            .standardSubTitleText()
                            .padding()
                            .standardBoxBackground()
                        }
                        else if currentStreak > 1 {
                            VStack {
                                Text("\(tag.id): \(currentStreak) days")
                                    .foregroundColor(.white)
                            }
                            .standardSubTitleText()
                            .padding()
                            .standardBoxBackground()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) //<-- Here
        }
        .padding(.top)
    }
    
    func groupSessionsByTag(sessions: [Session]) -> [String: TimeInterval] {
        
        // Initialize an empty dictionary to store session times grouped by tag
        var sessionsByTag: [String: TimeInterval] = [:]
        
        // Iterate through each session and group times based on their tag
        for session in sessions {
            let tag = session.tag  // Access the tag value
            
            // Add the session's total time to the corresponding tag entry
            sessionsByTag[tag, default: 0] += session.totalTime()  // Use default value of 0 if the tag doesn't exist
        }
        
        return sessionsByTag
    }
    
    // counts how many consective days you had a session until today
    // starts counting the day before and tries to go back day by day until it cannot find another consecutive session
    // currently does not count the sessions you have created on the current day
    func calculateStreak(for sessions: [Session], withTag tag: String) -> Int {
        var streakCount = 0
        
        // Start from yesterday, start from current day if there is an error
        var currentDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let calendar = Calendar.current
        
        // Loop while there are sessions for the tag on consecutive days
        while let _ = sessions.first(where: { calendar.isDate($0.startTime, inSameDayAs: currentDate) && $0.tag == tag }) {
            streakCount += 1
            // Move to the previous day
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
        }
        
        return streakCount
    }
}
