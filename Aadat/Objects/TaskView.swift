//
//  TaskView.swift
//  Aadat
//
//  Created by Ako Tako on 2/16/24.
//

import Foundation
import SwiftUI

/* Task Class Dec. */
class Task {
    var desc: String
    /* 0th tag should always be self (for display). Rest should be Parent Tags */
    var tag: String
    var parentTag: String
    var isPinned: Bool

    // TODO: use dictionary(?) of {Tag:start/end times}. all stats can be generated off start/end time
    
    func startTimer() {
        // TODO: start timer (get curr Date()?)
    }
    
    func endTimer () {
        // TODO: end timer (get curr Date()?)
    }
    
    init() {
        desc = "Add description"
        tag = ""
        parentTag = ""
        // TODO: refine logic on when/where we set isPinned on creation
        isPinned = true
    }
}

struct TaskView: View {
    
    var task: Task
    
    // TODO: display Tag, short desc., total time of Tag today, and timer button */
    var body: some View {
        HStack {
            VStack {
                Text(task.desc)
                Text(task.tag)
            }.padding()
            
            Spacer()
            
            VStack {
                // TODO: total time today, discuss session times as well
                TimerButtonView()
            }.padding()
        }
        .frame(maxWidth: .infinity)
        // TODO: make a better UI for this box
        .background(.gray)
        .padding()
    }
}

#Preview {
    Text("Preview not intended in TaskView?")
}
