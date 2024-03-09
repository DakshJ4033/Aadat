//
//  TaskView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData

/* Task Class Dec. */


struct TaskView: View {
    @Query private var tasks: [Task]
    @State var task: Task
    
    // TODO: display Tag, short desc., total time of Tag today, and timer button */
    // TODO: taskDesc is not updating the Object instance
    // TODO: tag should be a selectable field to scroll through all existing tags and change
    // TODO: add search bar to picker
    // TODO: see if NewTag sheet can be moved inside picker. wasn't working before
    
    @State var searchText: String = ""
    @State var showNewTagSheet: Bool = false
    @State var newTag: String = "New Tag"
    
    var body: some View {
            
        HStack {
            VStack(alignment: .leading) {
                // Task desc.
                TextField(task.taskDescription, text: $task.taskDescription)
                
                // assign a Tag from allTags or Add New
                HStack {
                    Text("Tag: ")
                    .multilineTextAlignment(.leading)
                    Button(task.tag) { // Half-sheet name entry
                        showNewTagSheet.toggle()
                    }.sheet(isPresented: $showNewTagSheet) {
                        //TODO: make this actually add tags to the userModel and push to disk
                        TextField("New Tag...", text: $newTag).defaultSheetDetents()
                    }
                }

                // A tag shouldn't be unique in order for this to work!
                Picker("Tags", selection: $task.tag) {
                    ForEach(tasks) { task in
                        Text("\(task.tag)").tag("\(task.tag)")
                    }
                }.pickerStyle(.menu)
            }
            .padding()
            
            Spacer()
            
            VStack {
                // TODO: total time today, discuss session times as well
                TimerButtonView(taskTag: task.tag)
            }
            /*.onChange(of: self.$task.desc) {
             // TODO: double check this references the actual Object? (push changes to disk?)
             task.desc = self.task.desc
             }*/
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(10)
        
    }
}

#Preview {
    Text("Preview not intended in TaskView?")
}
