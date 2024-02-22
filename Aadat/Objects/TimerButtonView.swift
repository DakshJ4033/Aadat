//
//  TimerButtonView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

struct TimerButtonView: View {
    @EnvironmentObject var userModel: UserModel
    @State var taskStarted = false
    
    var body: some View {
        Button {
            if !taskStarted {
                let newSession = Session()
                userModel.sessions.append(newSession)
            }
            taskStarted.toggle()
        } label: {
            Image(systemName: taskStarted ? "stop.circle.fill" : "play.circle.fill")
                .resizable() // Make the image resizable
                .frame(width: 24, height: 24)
                .foregroundColor(taskStarted ? .red : .blue)
        }
        .padding()
    }
}

#Preview {
    TimerButtonView()
}
