//
//  PinnedView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData

struct PinnedView: View {
    @Query(filter: #Predicate<Task> {$0.isPinned == true})
    private var pinnedTasks: [Task]
    @Query private var allTasks: [Task]
    
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {

        /* "All vs. Pinned Tasks" and "Show All" toggle */
        userModel.showAllTasks ? Text("All Tasks").standardTitleText() : Text("Pinned Tasks").standardTitleText()
        Toggle("Show All", isOn: $userModel.showAllTasks).standardText().padding()
        
        if (userModel.showAllTasks) {
            VStack {
                if allTasks.count != 0 {
                    ForEach(allTasks) { task in
                        TaskView(task: task)
                    }
                } else {
                    Text("No pinned tasks!").standardTitleText().separatorLine()
                    Spacer()
                }
            }
            .standardEncapsulatingBox()
        } else {
            VStack {
                if pinnedTasks.count != 0 {
                    ForEach(pinnedTasks) { task in
                        TaskView(task: task)
                    }
                } else {
                    Text("No pinned tasks!").standardTitleText().separatorLine()
                    Spacer()
                }
            }
            .standardEncapsulatingBox()
        }
    }
}

#Preview {
    PinnedView()
}
