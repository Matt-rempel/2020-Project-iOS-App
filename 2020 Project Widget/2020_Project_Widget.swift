//
//  _020_Project_Widget.swift
//  2020 Project Widget
//
//  Created by Matthew Rempel on 2020-08-20.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct DevoTimeline: IntentTimelineProvider {

    let dbAccessor = DBAccessor()

	func placeholder(in context: Context) -> LastDevoSnippetEntry {
		let devotion = Devotion()
		return LastDevoSnippetEntry(date: Date(), devotion: devotion)
	}

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (LastDevoSnippetEntry) -> Void) {
        let devotion = Devotion()
		let entry = LastDevoSnippetEntry(date: Date(), devotion: devotion)
		completion(entry)
        dbAccessor.getWidget { (devotion, error) in
            if let devotion = devotion {
                let entry = LastDevoSnippetEntry(date: Date(), devotion: devotion)
                completion(entry)
            }

            if let error = error {
                let entry = LastDevoSnippetEntry(date: Date(), devotion: Devotion(error: error))
                completion(entry)
            }
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<LastDevoSnippetEntry>) -> Void) {

		let currentDate = Date()
//		var refreshDate = Calendar.current.date(byAdding: .hour, value: 12, to: currentDate)!
		let refreshDate = Calendar.current.date(bySettingHour: 0, minute: 1, second: 0, of: currentDate)!

        dbAccessor.getWidget { (devotion, error) in
            var entry: LastDevoSnippetEntry = LastDevoSnippetEntry(date: Date(), devotion: Devotion())

            if let devotion = devotion {
                entry = LastDevoSnippetEntry(date: Date(), devotion: devotion)
            }

            if let error = error {
                entry = LastDevoSnippetEntry(date: Date(), devotion: Devotion(error: error))
            }

            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }

    }
}

struct WidgetEntryView: View {
    var entry: LastDevoSnippetEntry

	@Environment(\.widgetFamily) var family: WidgetFamily

	var body: some View {
        switch family {
        case .systemSmall:
            SmallWidget(devotion: entry.devotion)
        case .systemMedium:
            MediumWidget(devotion: entry.devotion)
        case .systemLarge:
            LargeWidget(devotion: entry.devotion)
        default:
            MediumWidget(devotion: entry.devotion)
		}
	}
}

@main
struct ProjectWidget: Widget {
    let kind: String = "_020_Project_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: DevoTimeline()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Today's Devotional")
        .description("View today's devotional")
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
		let devotion = Devotion()

        WidgetEntryView(entry: LastDevoSnippetEntry(date: Date(), devotion: devotion))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
