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
    @State var allTags: [String]
    
    var body: some View {
        Button {
            allTags.append("New Tag")
        } label: {
            Image(systemName: "plus.circle.fill").font(.largeTitle).imageScale(.large)
        }
        .padding()
    }
}

#Preview {
    CreateTagButtonView(allTags: [])
}
