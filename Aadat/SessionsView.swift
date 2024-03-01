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
            if sessions.count != 0 {
                ForEach(sessions) { session in
                    SessionView(session: session)
                        .padding([.bottom], 30)
                        .cornerRadius(5)
                }
            } else {
                Text("There are no active sessions!")
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 0.606, saturation: 0.832, brightness: 0.875)/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10)
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .frame(maxWidth: .infinity)
        // TODO: make a better UI for this box
        .background(.blue)
        .cornerRadius(10)
    }
}

#Preview {
    SessionsView()
}
