//
//  SessionsCalendarView.swift
//  Aadat
//
//  Created by Sauvikesh Lal on 3/12/24.
//

import SwiftUI
import SwiftData

struct SessionsCalendarView: View {
    @Query private var sessions: [Session]
    
    @State private var dateSelected: DateComponents?
    @State private var displayEvents = false
    
    var body: some View {
        CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), sessions: sessions,
        dateSelected: $dateSelected,
        displayEvents: $displayEvents
        )
        .colorScheme(.dark)
        .sheet(isPresented: $displayEvents) {
            DaysEventsListView(dateSelected: $dateSelected, sessions: sessions)
                            .presentationDetents([.medium, .large])
                    }
                    .navigationTitle("Calendar View")
    }
}

#Preview {
    SessionsCalendarView()
}
