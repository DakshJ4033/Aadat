//
//  allTagsView.swift
//  Aadat
//
//  Created by Ako Tako on 2/17/24.
//

import Foundation
import SwiftUI

struct AllTagsView: View {
    
    //TODO: show all tags so user can manage their pinned/not pinned. can also manage deletion/creation
    
    @EnvironmentObject var userModel: UserModel

    var body: some View {
        VStack {
            /* Show all Tags so user can pin / search / unpin */
            Text("All tags go here")
            ForEach(0..<userModel.tasks.count, id: \.self) {i in
                TaskView(task: userModel.tasks[i])
            }
        }
        .padding()
    }
}

#Preview {
    AllTagsView()
}
