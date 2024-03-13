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
        /* Click to add empty Task/Session */
        // TODO: make this a persistent button that doesn't scroll away
        Button {
            showAddTaskOrSessionSheet.toggle()
        } label: {
             Label("Add", systemImage: "plus.circle")
                .foregroundStyle(Color(hex:standardDarkHex))
                .font(.headline)
        }
        .sheet(isPresented: $showAddTaskOrSessionSheet) {
            TaskOrSessionFormView()
        }
        .buttonStyle(.bordered)
        .background(Color(hex:standardBrightPinkHex))
        .cornerRadius(5)
        .controlSize(.large)
    }
}

#Preview {
    AddTaskOrSessionView()
}
