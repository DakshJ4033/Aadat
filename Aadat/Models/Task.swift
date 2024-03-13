//
//  Task.swift
//  Aadat
//
//  Created by Daksh Jain on 2/22/24.
//
import SwiftUI
import Foundation
import SwiftData

struct ColorComponents: Codable {
    var red: Float
    var green: Float
    var blue: Float

    var color: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue))
    }

    static func fromColor(_ color: Color) -> ColorComponents {
        let resolved = color.resolve(in: EnvironmentValues())
        return ColorComponents(
            red: resolved.red,
            green: resolved.green,
            blue: resolved.blue
        )
    }
}

@Model
final class Task {
    var taskDescription: String
    var isPinned: Bool
    // tag represents task name
    @Attribute(.unique) 
    var tag: String
    var color: ColorComponents
    var subTasks = [Task]()
    
    init(taskDescription: String = "",
         isPinned: Bool = false,
         tag: String = "No Tag", 
         color: ColorComponents = ColorComponents(red: 0, green: 0, blue: 0),
         subTasks: [Task] = [Task]()) {
        self.taskDescription = taskDescription
        self.isPinned = isPinned
        self.tag = tag
        self.color = color
        self.subTasks = subTasks
    }
}
