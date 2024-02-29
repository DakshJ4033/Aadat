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
            Text("                Sessions          ⏱️")
                .font(.title)
                .bold()
                .padding(.top)
                ForEach(sessions) { session in
                    SessionView(session: session)
                        .padding([.bottom], 30)
                        .cornerRadius(5)
                }
        }
        .frame(maxWidth: .infinity)
        // TODO: make a better UI for this box
        .background(.blue)
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    SessionsView()
}
