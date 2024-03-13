//
//  DaysEventsListView.swift
//  Aadat
//
//  Created by Sauvikesh Lal on 3/12/24.
//

import SwiftData
import SwiftUI


struct DaysEventsListView: View {
    @Binding var dateSelected: DateComponents?
    var sessions: [Session]
    
    
    var body: some View {
            let foundEvents = sessions.filter {$0.startTime.startOfDay == dateSelected?.date?.startOfDay}
            
            if foundEvents.count > 0 {
                // Iterate over each session in foundEvents and display its tag
                ForEach(foundEvents, id: \.id) { session in
                    HStack{
                        SessionView(session: session)
                    }
                }
            }
            else {
                Text("no sessions were done on this day")
            }
    }
}
