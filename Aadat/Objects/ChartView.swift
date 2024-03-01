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

struct ChartView: View {
    @Query private var sessions: [Session]
    
    let menuOptions = ["Week"]
    @State private var selectedOption = "Week"
    
    var body: some View {
        
        // Convert dictionary to array of DailyTimeData
        let dailyTimeData: [DailyTimeData] = groupSessionsByDay(sessions: sessions).map { date, interval in
            DailyTimeData(date: date, interval: interval)
        }
        
        let dailyTimeData2: [DailyTimeData] = groupSessionsByTag(sessions: sessions).map { date, interval in
            DailyTimeData(date: date, interval: interval)
        }
        
        HStack {
            Text("Hours:")
            Picker("", selection: $selectedOption) {
                ForEach(menuOptions, id: \.self) { option in
                    Text(option)
                }
            }
        }
        .pickerStyle(.menu) // Set the picker style to menu
        .accessibilityLabel(Text("Select duration")) // Set accessibility label (optional)
        
        VStack {
            Chart(dailyTimeData) { dataPoint in
                BarMark(
                    x: .value("Day", dataPoint.id), // Use date as x-axis label
                    y: .value("Total Time (Hours)",  dataPoint.timeInterval) // Convert to hours (optional)
                )
                .foregroundStyle(.blue) // Set color for bars (optional)
            }
            .chartYAxisLabel("Minutes")
            .frame(height:250)
            
            Spacer()
            
            Chart(dailyTimeData2) { dataPoint in
                SectorMark(
                    angle: .value(
                        Text(verbatim: dataPoint.id),
                        dataPoint.timeInterval
                    )
                )
                .foregroundStyle(
                    by: .value(
                        "Type", dataPoint.id
                    )
                    
                )
            }
            .frame(height:250)
        }
    }
    
    
    func groupSessionsByDay(sessions: [Session]) -> [String: TimeInterval] {
        
        
        // Initialize an empty dictionary with zero time for each day
        var sessionsByDay: [String: TimeInterval] = [
            "Sun": 0,
            "Mon": 0,
            "Tue": 0,
            "Wed": 0,
            "Thu": 0,
            "Fri": 0,
            "Sat": 0,
        ]
        
        // Add session times to their corresponding day name
        for session in sessions {
            let day = Calendar.current.startOfDay(for: session.startTime)
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE" // Use format for abbreviated day name
            let dayName = dayFormatter.string(from: day)
            sessionsByDay[dayName] = sessionsByDay[dayName, default: 0] + session.totalTime()
        }
        
        return sessionsByDay
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
    
    struct DailyTimeData: Identifiable {
        let id: String // Use the date as the unique identifier
        let timeInterval: TimeInterval
        
        init(date: String, interval: TimeInterval) {
            self.id = date
            self.timeInterval = interval
        }
    }
}
