//
//  PinnedView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI
import SwiftData

struct PinnedView: View {
    @Query(filter: #Predicate<Task> {$0.isPinned == true})
    
    private var tasks: [Task]
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        // TODO: make pinniing actually an editable thing from UI perspective?
        
        VStack {
            HStack {
                Text("Pinned Tasks").standardTitleText()
                Toggle("Show All", isOn: $userModel.showAllTasks).standardText().padding()
            }
            if tasks.count != 0 {
                ForEach(tasks) { task in
                    TaskView(task: task)
                }
            } else {
                Text("No pinned tasks!").standardTitleText().separatorLine()
                Spacer()
            }
        }
        .standardEncapsulatingBox()
    }
}

#Preview {
    PinnedView()
}
