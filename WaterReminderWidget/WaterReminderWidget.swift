//
//  WaterReminderWidget.swift
//  WaterReminderWidget
//
//  Created by veronica on 1/10/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    let groupUserDefaults = UserDefaults(suiteName: "group.com.verozhao.waterreminder")
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), glassCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let count = groupUserDefaults?.integer(forKey: "glassCount") ?? 0
        let entry = SimpleEntry(date: Date(), glassCount: count)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let count = groupUserDefaults?.integer(forKey: "glassCount") ?? 0
        let entry = SimpleEntry(date: Date(), glassCount: count)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let glassCount: Int
}

struct WaterReminderWidgetEntryView : View {
    var entry: Provider.Entry
    
    struct AddWaterIntent: AppIntent, CustomStringConvertible {
        var description: String {
            return "Add Water"
        }
        
        static var title: LocalizedStringResource = "Add Water"
        
        func perform() async throws -> some IntentResult {
            let currentCount = UserDefaults.standard.integer(forKey: "glassCount")
            if currentCount < 8 {
                UserDefaults.standard.set(currentCount + 1, forKey: "glassCount")
            }
            return .result()
        }
    }
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            Button {
                Task {
                    try? await AddWaterIntent().perform()
                }
            } label: {
                VStack(spacing: 2) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                    Text("\(entry.glassCount)/8")
                        .font(.system(size: 12, weight: .bold))
                        .minimumScaleFactor(0.5)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct WaterReminderWidget: Widget {
    let kind: String = "WaterReminderWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WaterReminderWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Did I Drink?")
        .description("Track your daily water intake")
        .supportedFamilies([.accessoryCircular])
    }
}
