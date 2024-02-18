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

    var body: some View {
        HStack {
            /* Click to add empty Task/Session */
            Button {
                let newTask = Task()
                newTask.isPinned = true
                userModel.tasks.append(newTask)
            } label: {
                Text("Add Task/Session")
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
