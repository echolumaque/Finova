//
//  Frequency.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/25/25.
//

import Foundation

enum Frequency: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var startDate: Date {
        switch self {
        case .daily: .now.stripTime()
        case .weekly: Date.now.add(component: .day, value: -7)
        case .monthly: Date.now.add(component: .month, value: -1)
        case .yearly: Date.now.add(component: .year, value: -1)
        }
    }
}
