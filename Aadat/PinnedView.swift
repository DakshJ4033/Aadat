//
//  PinnedView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

struct PinnedView: View {
    
    @EnvironmentObject var userModel: UserModel

    var body: some View {
        // TODO: make pinniing actually an editable thing lol
        // TODO: currently shows all Tasks. reduce to only pinned = true? tasks
        VStack {
            Text("pinned Tasks")
            ForEach(0..<userModel.tasks.count, id: \.self) {i in
                TaskView(task: userModel.tasks[i])
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
