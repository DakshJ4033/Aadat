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
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        Button {
            /* don't dupe Tags */
            var dupeNum = 0
            while userModel.allTags.contains("New Tag \(dupeNum)") {
                dupeNum = dupeNum + 1
            }
            userModel.allTags.append("New Tag \(dupeNum)")
            userModel.updateAllTags()
            
        } label: {
            Image(systemName: "plus.circle.fill").font(.largeTitle).imageScale(.large)
        }
        .padding()
    }
}

#Preview {
    CreateTagButtonView()
}
