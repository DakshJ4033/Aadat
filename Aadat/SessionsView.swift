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
    @Query private var sessions: [Session]

    var body: some View {
        VStack {
            /* Show completed sessions */
            Text("Completed Sessions (On timer end, display here)")
//            
//            ForEach(0..<userModel.sessions.count, id: \.self) {i in
//                SessionView(session: userModel.sessions[i])
//            }
            ForEach(sessions) { session in
                SessionView(session: session)
            }
        }
        .frame(maxWidth: .infinity)
        // TODO: make a better UI for this box
        .background(.blue)
        .padding()
    }
}

#Preview {
    SessionsView()
}
