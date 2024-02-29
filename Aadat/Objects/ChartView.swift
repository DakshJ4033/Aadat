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

    //TODO: Sauvikesh please fix this Date() is confusing me
    
    var body: some View {
        @State var timeInMinutes: TimeInterval = 0
        
        Text(Date.now, format: .dateTime.day().month().year())

        Chart {
            let date = Calendar.current.date(from: DateComponents()) ?? .now
            let components = Calendar.current.dateComponents([.weekOfMonth], from: date)
            let week = components.weekOfMonth ?? 0
            
            BarMark(
                x: .value("Week", week),
                 y: .value("Time", timeInMinutes)
            )
        }
        .onAppear() {
            var timeInSeconds: TimeInterval = 0
            for session in sessions {
                timeInSeconds = timeInSeconds + session.totalTime()
            }
            timeInMinutes = timeInSeconds / 60
        }
        .padding()
    }
}
