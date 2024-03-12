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
    @EnvironmentObject var userModel: UserModel
    @State private var selectedOption = "All"
    
    var updatedMenuOptions: [String] {
        userModel.allTags // Directly access userModel here
    }
    
    var menuOptions: [String] {
        return ["All"] + updatedMenuOptions
    }
    
    var body: some View {
        
        
        let dailyTimeData2: [DailyTimeData] = groupSessionsByTag(sessions: sessions).map { date, interval in
            DailyTimeData(date: date, interval: interval)
        }
        
        let dailyTimeData3: [DailyTimeDataLineGraph] = sessions.compactMap { session in
            if (selectedOption == "All" || (session.tag == selectedOption)) {
                return DailyTimeDataLineGraph(date: session.startTime, interval: session.totalTime(), sessionTag: session.tag)
            }
            return nil
        }
        
        HStack {
            Text("Tag:")
                .foregroundStyle(.black)
            Picker("", selection: $selectedOption) {
                ForEach(menuOptions, id: \.self) { option in
                    Text(option)
                        .foregroundStyle(.black)
                }
            }
        }
        .pickerStyle(.menu) // Set the picker style to menu
        .accessibilityLabel(Text("Select duration")) // Set accessibility label (optional)
        .accentColor(.black) 
        .foregroundStyle(.black)
        .padding(10)
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.6509803921568628, green: 0.5098039215686274, blue: 1.0)/*@END_MENU_TOKEN@*/)
        .cornerRadius(10)
        .font(.headline)
        
        Spacer()
            .frame(height: 25)
        
        VStack {
            Chart(dailyTimeData3) {
                    LineMark(
                        x: .value("Date", $0.date),
                        y: .value("Time Spent", $0.timeInterval)
                    )
                    .foregroundStyle(by: .value("Tag", $0.sessionTag))
            }
            .chartYAxisLabel("Minutes")
            .frame(height:250)
            .padding(15)
            .background(.white)
            .cornerRadius(5)

            
            Spacer()
                .frame(height: 50)
            
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
            .padding(15)
            .background(.white)
            .cornerRadius(5)
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
    
    func groupSessionsByDayLifeTime(sessions: [Session]) -> [String: TimeInterval] {
        
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
    
    struct DailyTimeDataLineGraph: Identifiable {
        let id: UUID
        let date: Date
        let timeInterval: TimeInterval
        let sessionTag: String
        
        init(date: Date, interval: TimeInterval, sessionTag: String) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            
            self.date = calendar.date(from: DateComponents(year: components.year, month: components.month, day: components.day)) ?? Date()
            self.timeInterval = interval
            self.sessionTag = sessionTag
            self.id = UUID()
        }
    }

}
