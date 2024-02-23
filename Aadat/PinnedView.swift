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

    var body: some View {
        // TODO: make pinniing actually an editable thing from UI perspective?
        VStack {
            Text("pinned Tasks")
            ForEach(tasks) { task in
                TaskView(task: task)
            }
        }
        .frame(maxWidth: .infinity)
        // TODO: make a better UI for this box
        .background(.yellow)
    }
}

#Preview {
    PinnedView()
}
