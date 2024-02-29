//
//  TaskOrSessionFormView.swift
//  Aadat
//
//  Created by Sahil Khatri on 2/21/24.
//

import SwiftUI
import SwiftData

struct TaskOrSessionFormView: View {
    @Query private var tasks: [Task]
    @State private var task = Task()
    @State private var selectedTag = "No Tag"
    @State private var newTagName = ""
    @FocusState private var taskDescFieldIsFocused: Bool
    @State private var pinnedSelection: Bool = true
    
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
                    } else if (newTagName == "" && selectedTag != "No Tag") {
                        task.tag = selectedTag
                    } else {
                        print("Can't have a selected tag and a new tag at the same time!")
                    }
                    
                    context.insert(task)
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
                    HStack {
                        Text("Pinned:")
                        Button {
                            if pinnedSelection == true {
                                pinnedSelection = false
                            } else {
                                pinnedSelection = true
                            }
                        } label: {pinnedSelection ? Text("True") : Text("False")}
                    }
                    .padding([.bottom], 30)
                }
                
                // You can either add a new tag (Picker must have No Tag selected) or
                // pick a pre-existing tag (TextField should be empty)
                Section(header: Text("Tags")) {
                    if tasks.count > 0 {
                        Picker(selection: $selectedTag, content: {
                            Text("No Tag").tag("No Tag")
                            ForEach(tasks) { task in
                                Text("\(task.tag)").tag("\(task.tag)")
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "number")
                                Text("Tags")
                            }
                        })
                    }
                 
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

