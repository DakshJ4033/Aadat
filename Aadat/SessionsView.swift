//
//  SessionView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData

struct SessionsView: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @Environment(\.modelContext) var context
    @Query private var sessions: [Session]

    var body: some View {
        VStack {
            HStack {
                Text("Sessions").standardTitleText()
            }

            /* Show completed sessions */
            // Get today's date
            let today = Date()

            // Filter sessions based on startTime being today
            let todaySessions = sessions.filter { Calendar.current.isDate($0.startTime, inSameDayAs: today)  ||
                $0.endTime == nil
            }
            
            let groupedSessions = Dictionary(grouping: todaySessions, by: { $0.tag })
            
            Text("Sessions").standardTitleText()
            Text("Past 24 hours")
                .foregroundStyle(Color(hex: standardLightHex))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if todaySessions.count != 0 {
                Section {
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
                                .padding(.bottom, 8)
                        }
                    }
                    .accentColor(Color(hex:standardBrightPinkHex))
                    }
                } 
            }else {
                Spacer()
                Text("There are no recorded sessions!").standardText()
                Spacer()
            }
        }
        .standardEncapsulatingBox()
    }
    
    func delete(_ indexSet: IndexSet) {
        for i in indexSet {
            let session = sessions[i]
            context.delete(session)
        }
    }
}

#Preview {
    SessionsView()
}
