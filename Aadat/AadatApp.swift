//
//  AadatApp.swift
//  Aadat
//
//  Created by Daksh Jain on 2/15/24.
//

import SwiftUI
import SwiftData

@main
struct AadatApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }.modelContainer(for: [Task.self, Session.self])
    }
}
