//
//  TagView.swift
//  Aadat
//
//  Created by Ako Tako on 3/6/24.
//

import Foundation
import SwiftUI
import SwiftData
import SwipeActions

struct TagView: View {
    @Environment(\.modelContext) var context
    @Query private var tasks: [Task]
    @Query private var sessions: [Session]
    @State var pinnedStatus: String = "pin.slash"
    var task: Task
    
    var body: some View {
            VStack {
                SwipeView {
                    HStack {
                        Text(task.tag)
                            .standardText()
                        Spacer();Spacer()
                        /* pin/unpin */
                        Button {
                            pinOrUnpin()
                        } label: {
                            Image(systemName: pinnedStatus).font(.title2).imageScale(.medium)
                                .foregroundColor(Color(hex:standardBrightPinkHex))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .standardText()
                    .padding()
                    .standardBoxBackground()
                    .onAppear{ pinnedStatus = getPinnedStatus()}
                } trailingActions: { _ in
                    SwipeAction("Delete") {
                        for session in sessions {
                            if (session.tag == task.tag) {
                                session.tag = "No Tag"
                            }
                        }
                        context.delete(task)
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
            .padding()
    }
    
    func getPinnedStatus() -> String {
        return task.isPinned ? "pin.circle.fill" :  "pin.circle"
        // TODO: tag not found on a task????
    }
    
    func pinOrUnpin() {
        if (task.isPinned) {
            task.isPinned = false
            pinnedStatus = "pin.circle"
        } else {
            task.isPinned = true
            pinnedStatus = "pin.circle.fill"
        }
    }
}

#Preview {
    TagView(task: Task())
}
