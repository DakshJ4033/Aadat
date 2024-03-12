//
//  SessionView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData
import SwipeActions

struct SessionView: View {
    var session: Session
    
    @Environment(\.modelContext) var context
    @Query private var sessions: [Session]
    @State private var elapsedTime: TimeInterval = 0.0
    @State private var showSessionPopOver: Bool = false
    
    var body: some View {
        SwipeView {
            HStack {
                Text("\(session.tag)").lineLimit(1)
                Spacer()
                Text("\(formattedTime(from: elapsedTime))")
            }
            .frame(maxWidth: .infinity)
            .standardText()
            .padding()
            .standardBoxBackground()
            .onTapGesture {
                showSessionPopOver.toggle()
            }
            .sheet(isPresented: $showSessionPopOver) {
                SessionDetailedView(session: session, showSessionPopover: $showSessionPopOver)
                    .presentationDetents([.fraction(0.35)])
                    .presentationBackground(
                        Color(hex: standardDarkGrayHex)
                    )
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    if let unwrappedEndTime = session.endTime {
                        elapsedTime = unwrappedEndTime.timeIntervalSince(session.startTime)
                    } else {
                        elapsedTime = Date().timeIntervalSince(session.startTime)
                    }
                }
            }
        } trailingActions: { _ in
            SwipeAction("Delete") {
                context.delete(session)
            }
            .allowSwipeToTrigger()
            .standardText()
            .background(Color.red)
        }
        .swipeMinimumPointToTrigger(0.9)
        .swipeMinimumDistance(10)
        .swipeOffsetCloseAnimation(stiffness: 160, damping: 70)
        .swipeOffsetTriggerAnimation(stiffness: 500, damping: 600)
    }
    
    // function that nicely formats the string to display the time interval
    private func formattedTime(from time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
      }
}

#Preview {
    SessionView(session: Session(startTime: Date.now))
}
