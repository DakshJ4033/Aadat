//
//  LockscreenWidgetsBundle.swift
//  LockscreenWidgets
//
//  Created by Ako Tako on 3/4/24.
//

import WidgetKit
import SwiftUI

@main
struct LockscreenWidgetsBundle: WidgetBundle {
    var body: some Widget {
        LockscreenWidgets()
        LockscreenWidgetsLiveActivity()
    }
}
