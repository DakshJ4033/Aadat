//
//  TimerWidgetBundle.swift
//  TimerWidget
//
//  Created by Ako Tako on 3/7/24.
//

import WidgetKit
import SwiftUI

@main
struct TimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimerWidget()
        TimerWidgetLiveActivity()
    }
}
