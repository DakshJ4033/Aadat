//
//  TaskOrSessionFormView.swift
//  Aadat
//
//  Created by Sahil Khatri on 2/21/24.
//

import SwiftUI

struct TaskOrSessionFormView: View {
    
    @State private var taskName = ""
    @State private var taskDescription = ""
    @State private var showTagsSheet = false
    
    @FocusState private var taskNameFieldIsFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    
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
                } label: {
                    Text("Add")
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 15, trailing: 15))
                }
            }
            Form {
                Section(header: Text("Create Task")) {
                    TextField("Task Name", text: $taskName)
                        .focused($taskNameFieldIsFocused)
                    TextField("Task Description", text: $taskDescription)
                        .padding([.bottom], 30)
                }
                Section(header: Text("Tags")) {
                    Button {
                        showTagsSheet.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "number")
                            Text("Tags")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            .sheet(isPresented: $showTagsSheet, content: {
                
            })
            .onAppear() {
               taskNameFieldIsFocused = true
            }
        }
    }
}

#Preview {
    TaskOrSessionFormView()
}

