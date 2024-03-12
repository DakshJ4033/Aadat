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
    @EnvironmentObject var userModel: UserModel
    
    @State var newTagName: String = ""
    @State private var searchText = ""
    
    var body: some View {
        // ScrollView BREAKS Lists!!!
        /* Show all Tags so user can pin / search / unpin */
        ScrollView {
            VStack {
                Text("Tags").standardTitleText()
                ForEach(tasks) { task in
                    TagView(task: task)
                        .standardBoxBackground()
                }
            }.standardEncapsulatingBox()
        }
        .mainBackground()
    }
}

#Preview {
    ManageTagsView()
}
