//
//  TagView.swift
//  Aadat
//
//  Created by Ako Tako on 3/6/24.
//

import Foundation
import SwiftUI
import SwiftData

struct TagView: View {
    
    @Query private var tasks: [Task]
    @State var pinnedStatus: String = "pin.slash"
    var tag: String
    
    var body: some View {
        HStack {
            Text(tag)
            Spacer();Spacer()
            
            /* pin/unpin */
            Button {
                pinOrUnpin()
                
            } label: {
                /*if pinnedStatus == true {
                    Image(systemName: "pin.circle.fill").font(.title2).imageScale(.medium)
                } else if pinnedStatus == false {
                    Image(systemName: "pin.circle").font(.title2).imageScale(.medium)
                }*/
                Image(systemName: pinnedStatus).font(.title2).imageScale(.medium)

            }

        }.onAppear{ pinnedStatus = getPinnedStatus()}
        .cornerRadius(15)
        .padding()
        .background()
    }
    
    func getPinnedStatus() -> String {
        if tasks.count > 0 {
            for task in tasks {
                if task.tag == tag && task.isPinned {
                    return "pin.circle.fill"
                } else if task.tag == tag && !task.isPinned {
                    return "pin.circle"
                } // DEBUG else { print("\(tag) == \(task.tag)?")}
            }
        } else {
            print("no tasks found in PinnedStatus?")
        }
        print("\(tag) had no Task")
        return "pin.slash" // tag not found on a task
    }
    
    func pinOrUnpin() {
        if tasks.count > 0 {
            for task in tasks {
                if task.tag == tag && task.isPinned {
                    task.isPinned = false
                    pinnedStatus = "pin.circle"
                    return
                } else if task.tag == tag && !task.isPinned {
                    task.isPinned = true
                    pinnedStatus = "pin.circle.fill"
                    return
                } /*else {
                    print("No Tasks are using this tag")
                }*/
            }
        } else {
            print("No Tags available")
        }
        
    }
}

#Preview {
    TagView(tag: "Test Tag")
}
