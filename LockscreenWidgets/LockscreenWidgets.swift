//
//  LockscreenWidgets.swift
//  LockscreenWidgets
//
//  Created by Ako Tako on 3/4/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    /* //TODO: Init a placeholder while the real widget loads */
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    /* Provide Data to widgetView */
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
        //TODO: provide TIME since startTime (from Session) here. this is the "live data"?
    }
    
    /* //TODO: Provide times when widget needs to be updated */
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        
        //Auto gen'd
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

/* Put data here, like a viewModel */
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

/* The View you want to appear on the lockscreen */
struct LockscreenWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("I am a custom widget")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
        .containerBackground(for: .widget) {
            Color.purple
        }
    }
}

/* This is widget config. ENTRY point for widget display */
@main
struct LockscreenWidgets: Widget {
    let kind: String = "LockscreenWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            LockscreenWidgetsEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    LockscreenWidgets()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
