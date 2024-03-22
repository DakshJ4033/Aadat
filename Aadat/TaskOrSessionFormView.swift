//
//  TaskOrSessionFormView.swift
//  Aadat
//
//  Created by Sahil Khatri on 2/21/24.
//

import SwiftUI
import SwiftData

extension Color {
    static func random() -> ColorComponents {
        let colorComponent: ColorComponents = ColorComponents(red: Float.random(in: 0..<1),
                                                              green: Float.random(in: 0..<1), blue: Float.random(in: 0..<1))
        
        return colorComponent
    }
}

struct TaskOrSessionFormView: View {
    @EnvironmentObject var userModel: UserModel
    @Query private var tasks: [Task]
    @State private var task = Task()
    @State private var selectedTag = "No Tag"
    @State private var newTagName = ""
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
    
    fileprivate func addTask() {
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
            
            task.color = Color.random()
            task.isPinned = pinnedSelection
            context.insert(task)
            userModel.allTags.append(task.tag)
            userModel.updateAllTags()
        }
    }
    
    fileprivate func addSession() {
        if newTagName != "" && selectedTag == "No Tag" { // Case where user enters a new tag
            newSessionTag = newTagName
        } else if (newTagName == "") {
            newSessionTag = selectedTag
        }
        
        let newSession = Session(startTime: userStartTime, endTime: userEndTime, tag: newSessionTag)
        context.insert(newSession)
    }
    
    var body: some View {
        VStack {
            /* Form Top Bar */
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                        .bold()
                        .foregroundStyle(Color(hex: standardLightHex))
                })
                
                Spacer()
                
                Text("New \(selectedFormType == .taskForm ? "Task" : "Session")")
                    .bold()
                    .foregroundStyle(Color(hex: standardLightHex))
                
                Spacer()
                
                Button(action: {
                    if selectedFormType == .taskForm {
                        addTask()
                    } else {
                        addSession()
                    }
                    dismiss()
                }, label: {
                    Text("Add")
                        .bold()
                        .foregroundStyle(Color(hex: standardLightHex))
                })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Tag already exists!"))
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
                .colorMultiply(Color(hex: 0xD9A3DC))
                .pickerStyle(.segmented)
            }
            .background(Color(hex:standardLightHex))
            
            /* Create Task/Session Form */
            Form {
                Section {
                    /* Tag Picker */
                    Picker(selection: $selectedTag, content: {
                        ForEach(0..<userModel.allTags.count, id: \.self) { index in
                            Text("\(userModel.allTags[index])").tag("\(userModel.allTags[index])")
                        }
                    }, label: {
                        Text("Tag").standardText()
                    })
                    .tint(Color(hex: standardLightHex))
                    .listRowBackground(Color(hex: standardDarkHex))
                    
                    /* Type New Tag */
                    TextField(text: $newTagName, label: {
                        Text("Enter New Tag...").standardText()
                    })
                    .standardText()
                    .listRowBackground(Color(hex: standardDarkHex))
                }
                
                if selectedFormType == .taskForm {
                    Section {
                        Toggle(isOn: $pinnedSelection, label: {
                            Text("Pin Task?").standardText()
                        }).listRowBackground(Color(hex: standardDarkHex))
                    }
                } else {
                    Section {
                        DatePicker("Start Time:", selection: $userStartTime, displayedComponents: [.date, .hourAndMinute])
                            .standardText()
                            .datePickerStyle(.compact)
                            .tint(Color(hex: standardBrightPinkHex))
                            .environment(\.colorScheme, .dark)
                    
                        DatePicker("End Time:", selection: $userEndTime, displayedComponents: [.date, .hourAndMinute])
                            .opacity(onGoingTask ? 0:1)
                            .standardText()
                            .datePickerStyle(.compact)
                            .tint(Color(hex: standardBrightPinkHex))
                            .environment(\.colorScheme, .dark)
                    }
                    .listRowBackground(Color(hex: standardDarkHex))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(hex: standardDarkGrayHex))
        }
        .background(Color(hex: standardDarkGrayHex))
    }
}

#Preview {
    TaskOrSessionFormView()
}
