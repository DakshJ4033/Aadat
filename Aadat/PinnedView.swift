//
//  PinnedView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData
import TipKit

struct PinnedView: View {
    @Query(filter: #Predicate<Task> {$0.isPinned == true})
    private var pinnedTasks: [Task]
    @Query private var allTasks: [Task]
    @State private var showPopOver: Bool = false
    
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {

        /* "All vs. Pinned Tasks" and "Show All" toggle */
        HStack {
            userModel.showAllTasks ? Text("All Tasks").standardTitleText() : Text("Pinned Tasks").standardTitleText()
            Spacer()
            Button {
                showPopOver.toggle()
            } label: {
                Text("Hint")
                    .foregroundStyle(Color(hex: standardBrightPinkHex))
            }
            .popover(isPresented: $showPopOver, attachmentAnchor: .point(.bottomLeading)) {
                Text("Swipe left to delete tasks and sessions!\n\n\n If you have a language task set like \"Japanese\" then the task will automatically start if you start speaking Japanese!")
                    .standardText()
                    .background(Color(hex:standardDarkGrayHex))
                    .presentationCompactAdaptation(.popover)
                    .presentationBackground(Color(hex:standardDarkGrayHex))
                    .frame(width: 300, height: 200)
                    .padding()
            }
        }
        Toggle("Show All", isOn: $userModel.showAllTasks).standardText().padding(.bottom)
        
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
