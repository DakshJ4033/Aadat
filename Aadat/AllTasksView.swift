//
//  PinnedView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData

struct AllTasksView: View {
    @Query private var tasks: [Task]
    @EnvironmentObject var userModel: UserModel

    var body: some View {
        VStack {
            HStack {
                Text("All Tasks").standardTitleText()
                Toggle("Show All", isOn: $userModel.showAllTasks).standardText().padding()
            }
            if tasks.count != 0 {
                ForEach(tasks) { task in
                    TaskView(task: task)
                }
            } else {
                Text("There are no tasks!").standardTitleText().separatorLine()
                Spacer()
            }
        }
        .standardEncapsulatingBox()
    }
}

#Preview {
    AllTasksView()
}
