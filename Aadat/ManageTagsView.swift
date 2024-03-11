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
        NavigationStack {
            ZStack {
                /* Show all Tags so user can pin / search / unpin */
                List {
                    ForEach(searchResults, id: \.self) { tag in
                        TagView(tag: tag)
                    }
                    .listRowSeparator(.hidden, edges: .all)
                }
                //.listStyle(.plain)
                .navigationTitle("Tags")
                .searchable(text: $searchText)
                
                /*VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        CreateTagButtonView()
                    }
                }*/
            }
        }
        .environmentObject(userModel)
        //.cornerRadius(15)
        //.mainBackground()
        //.padding()
        //.background()
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return userModel.allTags
        } else {
            return userModel.allTags.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

#Preview {
    ManageTagsView()
}
