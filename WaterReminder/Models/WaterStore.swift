//
//  WaterStore.swift
//  WaterReminder
//
//  Created by veronica on 1/10/25.
//

import Foundation
import WidgetKit

class WaterStore: ObservableObject {
    private let groupUserDefaults = UserDefaults(suiteName: "group.com.verozhao.waterreminder")
    
    @Published var glassCount: Int {
        didSet {
            groupUserDefaults?.set(glassCount, forKey: "glassCount")
            groupUserDefaults?.set(Date(), forKey: "lastUpdated")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    init() {
        let lastUpdated = groupUserDefaults?.object(forKey: "lastUpdated") as? Date ?? Date()
        
        if !Calendar.current.isDate(lastUpdated, inSameDayAs: Date()) {
            groupUserDefaults?.set(0, forKey: "glassCount")
        }
        
        self.glassCount = groupUserDefaults?.integer(forKey: "glassCount") ?? 0
    }
    
    func addGlass() {
        if glassCount < 8 {
            glassCount += 1
        }
    }
    
    func resetCount() {
        glassCount = 0
    }
}
