//
//  Task.swift
//  Aadat
//
//  Created by Daksh Jain on 2/22/24.
//

import Foundation
import SwiftData

@Model
final class Task {
    var taskDescription: String
    var isPinned: Bool
    // tag represents task name
    @Attribute(.unique) 
    var tag: String
    var subTasks = [Task]()
    var sessions = [Session]()
    
    init(taskDescription: String = "", 
         isPinned: Bool = false,
         tag: String = "No Tag", 
         subTasks: [Task] = [Task](),
         sessions: [Session] = [Session]()) {
        self.taskDescription = taskDescription
        self.isPinned = isPinned
        self.tag = tag
        self.subTasks = subTasks
        self.sessions = sessions
    }
}
