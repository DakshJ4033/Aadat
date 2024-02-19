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
    
    var body: some View {
        Button {
            let newSession = Session()
            userModel.sessions.append(newSession)
        } label: {
            Image(systemName: "play.circle.fill")
        }
        .padding()
    }
}

#Preview {
    TimerButtonView()
}
