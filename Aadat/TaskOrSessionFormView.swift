//
//  TaskOrSessionFormView.swift
//  Aadat
//
//  Created by Sahil Khatri on 2/21/24.
//

import SwiftUI

struct TaskOrSessionFormView: View {
    @EnvironmentObject var userModel: UserModel
    @State private var taskDescription = ""
    
    @State private var tagName = ""
    @State private var selectedTagIndex = 0
    
    @FocusState private var taskDescFieldIsFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    
    func addTask() {
        let newTask = Task(defaultNoTagStr: "")
        newTask.desc = taskDescription
        newTask.isPinned = true
        newTask.tag = userModel.allTags[selectedTagIndex]
        newTask.parent = nil
        userModel.tasks.append(newTask)
        dismiss()
    }
    
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
                    addTask()
                } label: {
                    Text("Add")
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 15, trailing: 15))
                }
            }
            Form {
                Section(header: Text("Create Task")) {
                    TextField("Task Description", text: $taskDescription)
                        .focused($taskDescFieldIsFocused)
                        .padding([.bottom], 30)
                }
                Section(header: Text("Tags")) {
                    Picker(selection: $selectedTagIndex, content: {
                        ForEach(0..<userModel.allTags.count, id: \.self) {index in
                            Text("\(userModel.allTags[index])")
                                .tag(index)
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "number")
                            Text("Tags")
                        }
                    })
                    TextField("Add New Tag...", text: $tagName)
                        .onSubmit {
                            userModel.allTags.append(tagName)
                            tagName = ""
                            selectedTagIndex = userModel.allTags.count - 1
                        }
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

