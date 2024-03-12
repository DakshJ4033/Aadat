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
    //@State var pinnedStatus: String = "pin.slash"
    var task: Task
    
    var body: some View {
            VStack {
                SwipeView {
                    HStack {
                        Text(task.tag).standardText()
                        PinButtonView(task: task)
                    }
                    .frame(maxWidth: .infinity)
                    .standardText()
                    .padding()
                    .standardBoxBackground()
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
}

#Preview {
    TagView(task: Task())
}
