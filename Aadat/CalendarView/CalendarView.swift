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
        
        init(parent: CalendarView, sessions: [Session]) {
            self.parent = parent
            self.sessions = sessions
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView,
                          decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            
            let foundEvents = sessions.filter {$0.startTime.startOfDay == dateComponents.date?.startOfDay}
            if foundEvents.isEmpty { return nil }
            
            // Array of colors for the dots
            let dotColors: [UIColor] = [.red, .blue, .green, .yellow, .orange] // Add more colors as needed
            
            // Create a container view to hold all the dots
            let containerView = UIView()
            
            // Calculate the spacing between the dots
            let dotSpacing: CGFloat = 5.0
            
            // Calculate the total width needed for the dots
            let totalWidth = CGFloat(foundEvents.count) * dotSpacing
            
            // Initial x-position
            var currentX: CGFloat = 0.0
            
            // Index for selecting colors from the dotColors array
            var colorIndex = 0
            
            for _ in foundEvents {
                let icon = UILabel()
                icon.text = "•" // Unicode character for a bullet point
                icon.font = UIFont.systemFont(ofSize: 20)
                icon.textColor = dotColors[colorIndex % dotColors.count] // Assign color from the dotColors array
                icon.textAlignment = .center
                icon.backgroundColor = UIColor.black // Background color of the dot
                icon.layer.cornerRadius = 2 // Make it circular
                icon.clipsToBounds = true // Ensure the corner radius takes effect
                
                // Set the frame for the dot
                icon.frame = CGRect(x: currentX, y: 0, width: 28, height: 28) // Adjust width and height as needed
                
                // Add the dot to the container view
                containerView.addSubview(icon)
                
                // Update the current x-position for the next dot
                currentX += dotSpacing
                
                // Increment the color index for the next dot
                colorIndex += 1
            }
            
            // Adjust the frame of the container view to fit all the dots
            containerView.frame = CGRect(x: 0, y: 0, width: totalWidth, height: 40) // Adjust height as needed
            
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

