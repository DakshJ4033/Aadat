//
//  TaskView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

/* Task Class Dec. */
@Observable
class Task {
    var desc: String
    var isPinned: Bool
    
    var tag: String
    var parent: Task?
    
    // TODO: use dictionary(?) of {Tag:start/end times}. all stats can be generated off start/end time
    
    init(defaultNoTagStr: String) {
        desc = "Add description"
        tag = defaultNoTagStr
        parent = nil
        // TODO: refine logic on when/where we set isPinned on creation
        isPinned = true
    }
}

struct TaskView: View {
    
    @EnvironmentObject var userModel: UserModel
    
    @State private var task: Task
    
    init(task: Task) {
        self.task = task
    }
    
    // TODO: display Tag, short desc., total time of Tag today, and timer button */
    // TODO: taskDesc is not updating the Object instance
    // TODO: tag should be a selectable field to scroll through all existing tags and change
    
    var body: some View {
        
        @State var searchText: String = ""
        @State var showingSheet: Bool = false
        @State var newTag: String = "New Tag"
        
        HStack {
            VStack {
                // Task desc.
                TextField(task.desc, text: self.$task.desc)
                
                // assign a Tag from allTags
                Picker(task.tag, selection: $userModel.allTags[0]) {
                    ForEach(userModel.allTags, id: \.self) { i in
                        Text(i)
                    }
                }.pickerStyle(.menu)
                
                // Create a new Tag
            }
            .padding()
            
            Spacer()
            
            VStack {
                // TODO: total time today, discuss session times as well
                TimerButtonView()
            }
            /*.onChange(of: self.$task.desc) {
             // TODO: double check this references the actual Object? (push changes to disk?)
             task.desc = self.task.desc
             }*/
            .padding()
        }
        .frame(maxWidth: .infinity)
        // TODO: make a better UI for this box
        .background(.gray)
        .padding()
    }
}

#Preview {
    Text("Preview not intended in TaskView?")
}
