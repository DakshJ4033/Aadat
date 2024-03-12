//
//  PinButtonView.swift
//  Aadat
//
//  Created by Ako Tako on 3/12/24.
//

import Foundation
import SwiftUI

struct PinButtonView: View {

    @State private var pinnedStatus: String = "pin.slash"
    var task: Task
    
    var body: some View {
        Button {
            pinOrUnpin()
        } label: {
            Image(systemName: pinnedStatus)
                .foregroundColor(Color(hex:standardBrightPinkHex))
                .font(.title2)
        }
        .onAppear{pinnedStatus = getPinnedStatus()}
    }
    
    func getPinnedStatus() -> String {
        return task.isPinned ? "pin.circle.fill" :  "pin.circle"
        // TODO: tag not found on a task????
    }
    
    func pinOrUnpin() {
        if (task.isPinned) {
            task.isPinned = false
            pinnedStatus = "pin.circle"
        } else {
            task.isPinned = true
            pinnedStatus = "pin.circle.fill"
        }
    }
    
}

