//
//  AddTaskOrSessionView.swift
//  Aadat
//
//  Created by Ako Tako on 2/17/24.
//

import Foundation
import SwiftUI

struct AddTaskOrSessionView: View {
    
    @State var showAddTaskOrSessionSheet = false

    var body: some View {
        HStack {
            /* Click to add empty Task/Session */
            // TODO: make this a persistent button that doesn't scroll away
            Button ("Add Detailed Task") {
                showAddTaskOrSessionSheet.toggle()
            }
            .sheet(isPresented: $showAddTaskOrSessionSheet) {
                TaskOrSessionFormView()
            }
        }
        .frame(maxWidth: .infinity)
        // TODO: Button UI
        .background(.green)
        .padding()
    }
}

#Preview {
    AddTaskOrSessionView()
}
