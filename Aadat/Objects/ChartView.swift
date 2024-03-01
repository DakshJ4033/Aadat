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
        
        Chart(dailyTimeData) { dataPoint in
          BarMark(
            x: .value("Day", dataPoint.id), // Use date as x-axis label
            y: .value("Total Time (Hours)",  dataPoint.timeInterval) // Convert to hours (optional)
          )
          .foregroundStyle(.blue) // Set color for bars (optional)
        }
    }
    
    func groupSessionsByDay(sessions: [Session]) -> [String: TimeInterval] {
      // Get today's date and adjust calendar for Sunday first
      let today = Date()
      var calendar = Calendar.current
      calendar.firstWeekday = 1

      // Get the start of the current week (Sunday)
      var startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

      // Initialize an empty dictionary with zero time for each day
      var sessionsByDay: [String: TimeInterval] = [:]
      for _ in 0..<7 {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE" // Use format for abbreviated day name (e.g., Mon)
        let dayName = dayFormatter.string(from: startOfWeek)
        sessionsByDay[dayName] = 0
        startOfWeek = calendar.date(byAdding: .day, value: 1, to: startOfWeek)!
      }

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
    
    struct DailyTimeData: Identifiable {
      let id: String // Use the date as the unique identifier
      let timeInterval: TimeInterval

      init(date: String, interval: TimeInterval) {
        self.id = date
        self.timeInterval = interval
      }
    }
}
