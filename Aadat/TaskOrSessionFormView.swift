//
//  TaskOrSessionFormView.swift
//  Aadat
//
//  Created by Sahil Khatri on 2/21/24.
//

import SwiftUI
import SwiftData

struct TaskOrSessionFormView: View {
    @EnvironmentObject var userModel: UserModel
    @Query private var tasks: [Task]
    @State private var task = Task()
    @State private var selectedTag = "No Tag"
    @State private var newTagName = ""
    @FocusState private var taskDescFieldIsFocused: Bool
    @State private var pinnedSelection: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .padding(EdgeInsets(top: 20, leading: 15, bottom: 15, trailing: 0))
                }
                Spacer()
                    .frame(width: 95)
                Text("New Task")
                    .font(.headline)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 15, trailing: 0))
                Spacer()
                Button {
                    // TODO: Implement task/session creation logic
                    
                    if newTagName != "" && selectedTag == "No Tag" { // Case where user enters a new tag
                        task.tag = newTagName
                    } else if (newTagName == "") {
                        task.tag = selectedTag
                    }
                    
                    task.isPinned = pinnedSelection
                    
                    context.insert(task)
                    
                    userModel.allTags.append(task.tag)
                    userModel.updateAllTags()
                    
                    dismiss()
                } label: {
                    Text("Add")
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 15, trailing: 15))
                }
            }
            Form {
                Section(header: Text("Create Task")) {
                    TextField("Task Description", text: $task.taskDescription)
                        .focused($taskDescFieldIsFocused)
                        .padding([.bottom], 30)
                }
                
                Section(header: Text("Pinned?")) {
                    Toggle("Pin Task?", isOn: $pinnedSelection)
                }
                
                // You can either add a new tag (Picker must have No Tag selected) or
                // pick a pre-existing tag (TextField should be empty)
                Section(header: Text("Tags")) {
                    Picker(selection: $selectedTag, content: {
                        if tasks.count < 1 {
                            Text("No Tag").tag("No Tag")
                        }
                        ForEach(0..<userModel.allTags.count, id: \.self) { index in
                            Text("\(userModel.allTags[index])").tag("\(userModel.allTags[index])")
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "number")
                            Text("Tags")
                        }
                    })
                 
                    TextField("Add New Tag...", text: $newTagName)
                }
                 
                 
            }
            .onAppear() {
               taskDescFieldIsFocused = true
            }
        }
    }
}

#Preview {
    TaskOrSessionFormView()
}

