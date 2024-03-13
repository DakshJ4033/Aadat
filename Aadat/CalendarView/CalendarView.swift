//
//  CalendarView.swift
//  Aadat
//
//  Created by Sauvikesh Lal on 3/12/24.
//

import SwiftUI
import SwiftData

struct CalendarView: UIViewRepresentable {
    
    let interval: DateInterval
    var sessions: [Session]
    @Binding var dateSelected: DateComponents?
    @Binding var displayEvents: Bool
    
    
    func makeUIView(context: Context) -> some UICalendarView {
        let view = UICalendarView()
        
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        // Customize the appearance of the calendar view
        
        let hexValue: UInt32 = 0xC36AC0

        // Extract red, green, and blue components
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0x0000FF) / 255.0

        // Create a UIColor object with the extracted components
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        view.tintColor = color
 
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, sessions: self.sessions)
    }
        
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
        
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarView
        var sessions: [Session]
        var foundEvents: [Session]
        
        init(parent: CalendarView, sessions: [Session]) {
            self.parent = parent
            self.sessions = sessions
            self.foundEvents = [] // Initialize foundEvents
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView,
                          decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            
            foundEvents = sessions.filter {$0.startTime.startOfDay == dateComponents.date?.startOfDay}
            if foundEvents.isEmpty { return nil }
            
            let uiColor = UIColor(red: 0.443, green: 0.35294117647058826, blue: 1.0, alpha: 1.0)
            
            
            return UICalendarView.Decoration.default(color: uiColor, size: .large)
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           didSelectDate dateComponents: DateComponents?) {
            parent.dateSelected = dateComponents
            guard let dateComponents else { return }
            _ = sessions
                .filter {$0.startTime == dateComponents.date}
            
            parent.displayEvents.toggle()
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
        
    }
}

