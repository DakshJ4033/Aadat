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
                
                // TODO: this section breaks the app??
                /*
                Section(header: Text("Tags")) {
                    Picker(selection: $task.tag, content: {
//                        ForEach(0..<userModel.allTags.count, id: \.self) {index in
//                            Text("\(userModel.allTags[index])")
//                                .tag(index)
//                        }
                        ForEach(tasks) { task in
                            Text("\(task.tag)")
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "number")
                            Text("Tags")
                        }
                    })
                 
                    TextField("Add New Tag...", text: $task.tag)
                        .onSubmit {
//                            userModel.allTags.append(tagName)
//                            tagName = ""
//                            selectedTagIndex = userModel.allTags.count - 1
                            // TODO: DO SOMETHING HERE
                        }
                }
                 */
                 
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

