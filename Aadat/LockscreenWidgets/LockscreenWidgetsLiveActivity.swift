//
//  LockscreenWidgetsLiveActivity.swift
//  LockscreenWidgets
//
//  Created by Ako Tako on 3/4/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LockscreenWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LockscreenWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LockscreenWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LockscreenWidgetsAttributes {
    fileprivate static var preview: LockscreenWidgetsAttributes {
        LockscreenWidgetsAttributes(name: "World")
    }
}

extension LockscreenWidgetsAttributes.ContentState {
    fileprivate static var smiley: LockscreenWidgetsAttributes.ContentState {
        LockscreenWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LockscreenWidgetsAttributes.ContentState {
         LockscreenWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LockscreenWidgetsAttributes.preview) {
   LockscreenWidgetsLiveActivity()
} contentStates: {
    LockscreenWidgetsAttributes.ContentState.smiley
    LockscreenWidgetsAttributes.ContentState.starEyes
}
