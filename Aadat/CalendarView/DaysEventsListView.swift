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
            
            let groupedSessions = Dictionary(grouping: foundEvents, by: { $0.tag })
            if foundEvents.count > 0 {
                ScrollView {
                    ForEach(groupedSessions.keys.sorted(), id: \.self) { sessionTag in
                        DisclosureGroup {
                            if let sessionsForTag = groupedSessions[sessionTag] {
                                ForEach(sessionsForTag) { session in
                                    SessionView(session: session)
                                }
                            }
                        }
                    label: {
                        VStack(alignment: .leading) {
                            Text(sessionTag)
                                .standardTitleText()
                                .padding(8)
                        }
                    }
                    .accentColor(.white)
                    }
                }
            }
            else {
                Text("no sessions were done on this day")
            }
    }
}
