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
                    .standardText()
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
            .background(Color(hex: 0x18101F))
            Form {
                Section(header: Text("Create Task").standardText()) {
                    TextField(text: $task.taskDescription, label: {
                        Text("Task Description").standardText()
                    })
                    .focused($taskDescFieldIsFocused)
                    .padding([.bottom], 30)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .standardText()
                    .listRowBackground(Color(hex: 0x18101F))
                }

                Section(header: Text("Pinned?").standardText()) {
                    Toggle(isOn: $pinnedSelection, label: {
                        Text("Pin Task?").standardText()
                    })
                    .listRowBackground(Color(hex: 0x18101F))
                }
                
                // You can either add a new tag (Picker must have No Tag selected) or
                // pick a pre-existing tag (TextField should be empty)
                Section(header: Text("Tags").standardText()) {
                    Picker(selection: $selectedTag, content: {
                        if tasks.count < 1 {
                            Text("No Tag").tag("No Tag").standardText()
                        }
                        ForEach(0..<userModel.allTags.count, id: \.self) { index in
                            Text("\(userModel.allTags[index])").tag("\(userModel.allTags[index])")
                                .accentColor(.white)
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "number").foregroundColor(Color(hex: 0xEEDCF7))
                            Text("Tags").standardText()
                        }
                    })
                    .listRowBackground(Color(hex: 0x18101F))
                 
                    TextField(text: $newTagName, label: {
                        Text("Add New Tag...").standardText()
                    })
                    .standardText()
                    .listRowBackground(Color(hex: 0x18101F))
                }
                 
            }
            .scrollContentBackground(.hidden)
            .background(.black)
            .onAppear() {
               taskDescFieldIsFocused = true
            }
        }
        .background(.black)
    }
}

#Preview {
    TaskOrSessionFormView()
}

