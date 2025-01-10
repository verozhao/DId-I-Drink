//
//  AddWaterIntent.swift
//  WaterReminder
//
//  Created by veronica on 1/10/25.
//

import Foundation
import WidgetKit
import SwiftUI
import AppIntents

struct AddWaterIntent: AppIntent, CustomStringConvertible {
    var description: String {
        return "Add Water"
    }
    
    static var title: LocalizedStringResource = "Add Water"
    
    func perform() async throws -> some IntentResult {
        let groupUserDefaults = UserDefaults(suiteName: "group.com.verozhao.waterreminder")
        let currentCount = groupUserDefaults?.integer(forKey: "glassCount") ?? 0
        if currentCount < 8 {
            groupUserDefaults?.set(currentCount + 1, forKey: "glassCount")
            WidgetCenter.shared.reloadAllTimelines()
        }
        return .result()
    }
}
