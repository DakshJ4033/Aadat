//
//  SessionDetailedView.swift
//  Aadat
//
//  Created by Sauvikesh Lal on 2/19/24.
//

import SwiftUI

struct SessionDetailedView: View {
    var session: Session
    
    @State var userStartTime : Date = Date() + 60
    @State var userEndTime : Date = Date() + 60
    
    var body: some View {
        DatePicker("Please enter a start time", selection: $userStartTime, displayedComponents: .hourAndMinute)
        
        DatePicker("Please enter an end time", selection: $userEndTime, displayedComponents: .hourAndMinute)
        
        Button("submit times") {
            print(userStartTime)
            session.startTime = userStartTime
            session.endTime = userEndTime
            print(session.startTime)
        }
    }
}

#Preview {
    SessionDetailedView(session: Session(startTime: Date.now))
}
