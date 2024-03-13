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
    @State private var pinnedSelection: Bool = true
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State var userStartTime : Date = Date()
    @State var userEndTime : Date = Date()
    @State private var newSessionTag = ""
    @State private var onGoingTask: Bool = false

    
    
    enum FormType: String, CaseIterable, Identifiable {
        case taskForm, sessionForm
        var id: Self { self }
    }

    @State private var selectedFormType: FormType = .taskForm
    @State private var showAlert = false

    
    var body: some View {
        VStack {
            /* Form Top Bar */
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer().frame(maxWidth: .infinity)
                
                if selectedFormType == .taskForm {
                    Text("New Task").standardText()
                    Spacer().frame(maxWidth: .infinity)
                    Button("Add") {
                        
                        if newTagName.isEmpty {
                            newTagName = selectedTag
                        }
                        if userModel.allTags.contains(newTagName) {
                            showAlert = true
                        } else {
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
                        }
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text("Tag already exists!"))
                    }
                } else if selectedFormType == .sessionForm {
                    Text("New Session").standardText()
                    Spacer().frame(maxWidth: .infinity)
                    Button("Add") {
                        
                        if newTagName != "" && selectedTag == "No Tag" { // Case where user enters a new tag
                            newSessionTag = newTagName
                        } else if (newTagName == "") {
                            newSessionTag = selectedTag
                        }
                        
                        let newSession = Session(startTime: userStartTime, endTime: userEndTime, tag: newSessionTag)
                        context.insert(newSession)
                        dismiss()
                    }
                }
            }
            .padding()
            .background(Color(hex: standardDarkHex))
            
            /* Picker, changes form if creating a Task vs Session */
            HStack {
                Picker("FormType", selection: $selectedFormType) {
                    Text("Task").tag(FormType.taskForm)
                    Text("Session").tag(FormType.sessionForm)
                }
                .pickerStyle(.segmented)
            }.background(Color(hex:standardLightHex))
            
            /* Create Task/Session Form */
            if selectedFormType == .taskForm {
                Form {
                    Section {
                        /* Tag Picker */
                        Picker(selection: $selectedTag, content: {
                            if tasks.count < 1 {
                                Text("No Tag").tag("No Tag").standardText()
                            }
                            ForEach(0..<userModel.allTags.count, id: \.self) { index in
                                Text("\(userModel.allTags[index])").tag("\(userModel.allTags[index])")
                                    .accentColor(.white)
                            }
                        }, label: {
                            Text("Tag").standardText()
                        })
                        .listRowBackground(Color(hex: standardDarkHex))
                        
                        /* Type New Tag */
                        TextField(text: $newTagName, label: {
                            Text("Enter New Tag...").standardText()
                        })
                        .standardText()
                        .listRowBackground(Color(hex: standardDarkHex))
                    }
                    
                    /* Pin Task Toggle */
                    Section {
                        Toggle(isOn: $pinnedSelection, label: {
                            Text("Pin Task?").standardText()
                        }).listRowBackground(Color(hex: standardDarkHex))
                    }
                }
                .scrollContentBackground(.hidden)
                .background(.black)
                .onAppear() {
                    taskDescFieldIsFocused = true
                }
            } else if selectedFormType == .sessionForm {
                Form {
                    Section {
                        /* Tag Picker */
                        Picker(selection: $selectedTag, content: {
                            if tasks.count < 1 {
                                Text("No Tag").tag("No Tag").standardText()
                            }
                            ForEach(0..<userModel.allTags.count, id: \.self) { index in
                                Text("\(userModel.allTags[index])").tag("\(userModel.allTags[index])")
                                    .accentColor(.white)
                            }
                        }, label: {
                            Text("Tag").standardText()
                        }).listRowBackground(Color(hex: standardDarkHex))
                        
                        /* Type New Tag */
                        TextField(text: $newTagName, label: {
                            Text("Enter New Tag...").standardText()
                        })
                        .standardText()
                        .listRowBackground(Color(hex: standardDarkHex))
                    }
                    
                    Section {
                        DatePicker("Start Time:", selection: $userStartTime, displayedComponents: [.date, .hourAndMinute])
                            .standardText()
                            .datePickerStyle(.compact)
                            .tint(Color(hex: standardBrightPinkHex))
                            .environment(\.colorScheme, .dark) // <- This modifier
                    
                        DatePicker("End Time:", selection: $userEndTime, displayedComponents: [.date, .hourAndMinute])
                            .opacity(onGoingTask ? 0:1)
                            .standardText()
                            .datePickerStyle(.compact)
                            .tint(Color(hex: standardBrightPinkHex))
                            .environment(\.colorScheme, .dark) // <- This modifier
                    }.listRowBackground(Color(hex: standardDarkHex))
                }
                .scrollContentBackground(.hidden)
                .background(.black)
            }
        }
        .background(.black)
    }
}

#Preview {
    TaskOrSessionFormView()
}
