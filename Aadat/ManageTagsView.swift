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
    
    @State var allTags: [String] = []
    @State var newTagName: String = ""
    
    @State private var searchText = ""
    
    var body: some View {
        // ScrollView BREAKS Lists!!!
        NavigationStack {
            ZStack {
                VStack { /* Show all Tags so user can pin / search / unpin */
                    List {
                        ForEach(searchResults, id: \.self) { tag in
                            Text(tag)
                        }
                    }
                    .searchable(text: $searchText)
                    .navigationTitle("Tags")
                }.onAppear() {
                    for task in tasks {
                        !allTags.contains(task.tag) ? allTags.append(task.tag) : print("got dupe \(task.tag)")
                    }
                }
                
                VStack {
                    Spacer();Spacer()
                    HStack {
                        Spacer();Spacer()
                        CreateTagButtonView(allTags: allTags)
                    }
                }
            }
            
        }
        .padding()
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return allTags
        } else {
            return allTags.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

#Preview {
    ManageTagsView()
}
