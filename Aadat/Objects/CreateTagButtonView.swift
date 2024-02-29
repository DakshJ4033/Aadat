//
//  CreateTagButtonView.swift
//  Aadat
//
//  Created by Ako Tako on 2/28/24.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateTagButtonView: View {
    @Query private var tasks: [Task]
    @Binding var allTags: [String]
    
    var body: some View {
        Button {
            /* don't dupe Tags */
            var dupeNum = 0
            while allTags.contains("New Tag \(dupeNum)") {
                dupeNum = dupeNum + 1
            }
            allTags.append("New Tag \(dupeNum)")
            
        } label: {
            Image(systemName: "plus.circle.fill").font(.largeTitle).imageScale(.large)
        }
        .padding()
    }
}

#Preview {
    CreateTagButtonView(allTags: .constant([]))
}
