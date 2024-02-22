//
//  AddTaskOrSessionView.swift
//  Aadat
//
//  Created by Ako Tako on 2/17/24.
//

import Foundation
import SwiftUI

struct AddTaskOrSessionView: View {
    
    @EnvironmentObject var userModel: UserModel
    
    @State var showAddTaskOrSessionSheet = false

    var body: some View {
        HStack {
            /* Click to add empty Task/Session */
            // TODO: make this a persistent button that doesn't scroll away
            Button ("Add Task/Session") {
                showAddTaskOrSessionSheet.toggle()
//                let newTask = Task(defaultNoTagStr: userModel.defaultNoTagStr)
//                newTask.isPinned = true
//                userModel.tasks.append(newTask)
            }
            .sheet(isPresented: $showAddTaskOrSessionSheet) {
                TaskOrSessionFormView()
            }
        }
        .frame(maxWidth: .infinity)
        // TODO: Button UI
        .background(.green)
        .padding()
    }
}

#Preview {
    AddTaskOrSessionView()
}
