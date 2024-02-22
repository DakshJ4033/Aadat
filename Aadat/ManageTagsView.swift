//
//  allTagsView.swift
//  Aadat
//
//  Created by Ako Tako on 2/17/24.
//

import Foundation
import SwiftUI

struct ManageTagsView: View {
    
    //TODO: show all tags so user can manage their pinned/not pinned. can also manage deletion/creation
    
    @EnvironmentObject var userModel: UserModel

    var body: some View {
        ScrollView {
            VStack {
                /* Show all Tags so user can pin / search / unpin */
                // TODO: search bar
                // TODO: Add tag in top right button
                Text("All tags go here")
                ForEach(0..<userModel.tasks.count, id: \.self) {i in
                    TaskView(task: userModel.tasks[i])
                }
                ForEach(0..<userModel.allTags.count, id: \.self) {i in
                    Text("\(i): \(userModel.allTags[i])")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ManageTagsView()
}
