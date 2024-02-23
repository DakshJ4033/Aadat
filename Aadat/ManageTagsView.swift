//
//  allTagsView.swift
//  Aadat
//
//  Created by Ako Tako on 2/17/24.
//

import Foundation
import SwiftUI
import SwiftData

struct ManageTagsView: View {
    
    //TODO: show all tags so user can manage their pinned/not pinned. can also manage deletion/creation
    @Query private var tasks: [Task]

    var body: some View {
        ScrollView {
            VStack {
                /* Show all Tags so user can pin / search / unpin */
                // TODO: search bar
                // TODO: Add tag in top right button
                Text("All tags go here")
                ForEach(tasks) { task in
                    TaskView(task: task)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ManageTagsView()
}
