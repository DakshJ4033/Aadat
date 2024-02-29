//
//  TaskView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

/* Task Class Dec. */


struct TaskView: View {
    @State private var task: Task
    init(task: Task) {
        self.task = task
    }
    
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
            VStack {
                // Task desc.
                TextField(task.taskDescription, text: $task.taskDescription)
                
                // assign a Tag from allTags or Add New
                Button("New Tag...") { // Half-sheet name entry
                    showNewTagSheet.toggle()
                }.sheet(isPresented: $showNewTagSheet) {
                    //TODO: make this actually add tags to the userModel and push to disk
                    TextField("New Tag...", text: $newTag).defaultSheetDetents()
                }
                .padding([.trailing], 121)
//
//                Picker(task.tag, selection: $userModel.allTags[0]) {
//                    ForEach(userModel.allTags, id: \.self) { i in
//                        Text(i)
//                    }
//                }.pickerStyle(.menu)
            }.padding()
            
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
        .background(.white)
        .cornerRadius(10)
        .padding()
        
    }
}

#Preview {
    Text("Preview not intended in TaskView?")
}
