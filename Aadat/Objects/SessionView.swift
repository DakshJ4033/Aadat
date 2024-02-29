//
//  SessionView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

struct SessionView: View {
    var session: Session
    
    @State private var elapsedTime: TimeInterval = 0.0
    @State private var showAccountsPopOver: Bool = false
    
    var body: some View {
        HStack {
            Text("\(session.tag)")
                .lineLimit(1)
            Text("Time elapsed:")
            Text(formattedTime(from: elapsedTime))
        }
        .padding()
        .background(.white)
        .onTapGesture {
            showAccountsPopOver = true;
        }
        .popover(isPresented: $showAccountsPopOver) {
            SessionDetailedView(session: session)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                elapsedTime = Date().timeIntervalSince(session.startTime)
            }
          }
    }
    // function that nicely formats the string to display the time interval
    private func formattedTime(from time: TimeInterval) -> String {
        let minutes = Int(time / 60) % 60
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
      }
}

#Preview {
    SessionView(session: Session(startTime: Date.now))
}
