//
//  AddTaskOrSessionView.swift
//  Aadat
//
//  Created by Ako Tako on 2/17/24.
//

import Foundation
import SwiftUI

struct AddTaskOrSessionButtonView: View {
    
    @State var showAddTaskOrSessionSheet = false

    var body: some View {
        /* Click to add empty Task/Session */
        Button {
            showAddTaskOrSessionSheet.toggle()
        } label: {
             Label("Add", systemImage: "plus.circle")
                .foregroundStyle(Color(hex:standardDarkHex))
                .font(.headline)
        }
        .sheet(isPresented: $showAddTaskOrSessionSheet) {
            TaskOrSessionFormView()
                .presentationDetents([.fraction(0.50)])
                .presentationBackground(Color(hex: standardDarkGrayHex))
        }
        .buttonStyle(.bordered)
        .background(Color(hex:standardBrightPinkHex))
        .cornerRadius(5)
        .controlSize(.large)
        .padding()

    }
}

#Preview {
    AddTaskOrSessionButtonView()
}
