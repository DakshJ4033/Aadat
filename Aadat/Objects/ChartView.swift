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
            let frame = geometry[chartProxy.plotAreaFrame]
            VStack {
              Text("Top Task")
                .font(.callout)
                .foregroundStyle(.secondary)
              Text(groupedSessions.max(by: { $0.value < $1.value })?.key ?? "")
                .font(.title2.bold())
                .foregroundColor(.primary)
            }
            .position(x: frame.midX, y: frame.midY)
          }
        }
        .frame(height:250)
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
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        return streakCount
    }
    
//    func weekdayString(from date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEE" // This returns the abbreviated day of the week, e.g., "Mon"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Use a fixed locale to ensure consistency
//        return dateFormatter.string(from: date)
//    }
//    
//    private func fetchSessionData() {
//        // First, we need a dictionary that maps from (tag, weekday) to totalTime
//        var totalTimeByTagAndWeekday: [String: [(weekday: Date, totalTime: TimeInterval)]] = [:]
//        
//        var calendar = Calendar(identifier: .gregorian)
//        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Ensure the calendar is using UTC
//        
//        // Define the date range for the past week
//        let now = Date() // This is in your local time zone
//        guard let today = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now) else { return }
//        guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: today) else { return }
//
//        // Filter sessions that occurred within the last week
//        let sessionsPastWeek = sessions.filter {
//            $0.startTime >= oneWeekAgo && $0.startTime <= today
//        }
//        
//        // Debug print statements
//        print("All sessions:")
//        for session in sessions {
//            print("\(session.tag), \(session.startTime)")
//        }
//        
//        print("Sessions in the past week:")
//        for session in sessionsPastWeek {
//            print("\(session.tag), \(session.startTime)")
//        }
//        
//        for session in sessionsPastWeek {
//            // Extract the weekday from the session's startTime
//            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: session.startTime)
//            guard let weekday = calendar.date(from: components) else { continue }
//            
//            // Append the totalTime to the correct tag and weekday entry
//            if totalTimeByTagAndWeekday[session.tag] != nil {
//                if let index = totalTimeByTagAndWeekday[session.tag]?.firstIndex(where: { $0.weekday == weekday }) {
//                    totalTimeByTagAndWeekday[session.tag]?[index].totalTime += session.totalTime()
//                } else {
//                    totalTimeByTagAndWeekday[session.tag]?.append((weekday: weekday, totalTime: session.totalTime()))
//                }
//            } else {
//                totalTimeByTagAndWeekday[session.tag] = [(weekday: weekday, totalTime: session.totalTime())]
//            }
//        }
//        
//
//        // Now map the dictionary to your desired array structure
//        let result = totalTimeByTagAndWeekday.map { tag, weekData -> (String, [(Date, TimeInterval)]) in
//            return (tag, weekData.map { ($0.weekday, $0.totalTime) })
//        }
//        
//        // Define a function to map the weekday number to a sortable value with Monday as the first day
//        func sortValueForWeekday(date: Date) -> Int {
//            let weekday = Calendar.current.component(.weekday, from: date)
//            return weekday == 1 ? 7 : weekday - 1 // Adjust Sunday to be the last
//        }
//        
//        // Sort the tuples by weekday for each tag
//        let sortedResult = result.map { (tag: String, weekData: [(weekday: Date, totalTime: TimeInterval)]) -> (String, [(Date, TimeInterval)]) in
//            let sortedWeekData = weekData.sorted { (data1: (weekday: Date, totalTime: TimeInterval), data2: (weekday: Date, totalTime: TimeInterval)) -> Bool in
//                return data1.weekday < data2.weekday
//            }
//            return (tag, sortedWeekData)
//        }
//        
//        print(sortedResult)
//        // Store the sorted result in your state variable
//        self.groupedData = sortedResult
//    }

}
