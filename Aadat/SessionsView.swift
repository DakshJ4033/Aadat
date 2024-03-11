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
            Text("Sessions").standardTitleText()
            if sessions.count != 0 {
                ForEach(sessions) { session in
                    SessionView(session: session)
                }
            } else {
                Spacer()
                Text("There are no recorded sessions!").standardText()
                Spacer()
            }
        }
        .standardEncapsulatingBox()
    }
}

#Preview {
    SessionsView()
}
