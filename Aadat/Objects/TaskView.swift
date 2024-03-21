//
//  TaskView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData
import SwipeActions

/* Task Class Dec. */
struct TaskView: View {
    @Environment(\.modelContext) var context
    @Query private var tasks: [Task]
    @Query private var sessions: [Session]
    @State var task: Task
    @EnvironmentObject var userModel: UserModel

    @State var searchText: String = ""
    @State var showNewTagSheet: Bool = false
    @State var newTag: String = "New Tag"
    
    var body: some View {
        SwipeView {
            HStack {
                VStack {
                    // assign a Tag from allTags or Add New
                    HStack {
                        Text("Tag: ")
                        // A tag shouldn't be unique in order for this to work!
                        Picker("Tags", selection: $task.tag) {
                            ForEach(0..<userModel.allTags.count, id: \.self) { index in
                                Text("\(userModel.allTags[index])")
                                    .tag("\(userModel.allTags[index])")
                                    .standardText()
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(Color(hex: standardLightHex))
                    }.standardText()
                }
                .padding()
                HStack {
                    PinButtonView(task: task)
                    TimerButtonView(task: task)
                }
            }.standardBoxBackground()
        } trailingActions: { _ in
            SwipeAction("Delete") {
                for session in sessions {
                    if (session.tag == task.tag) {
                        session.tag = "No Tag"
                    }
                }
                for (index, tag) in userModel.allTags.enumerated() {
                    if task.tag == tag {
                        userModel.allTags.remove(at: index)
                        return
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
}

#Preview {
    Text("Preview not intended in TaskView?")
}
