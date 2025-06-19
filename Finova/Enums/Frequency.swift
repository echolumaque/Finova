//
//  Frequency.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/25/25.
//

import Foundation

enum Frequency: Int, CaseIterable {
    case daily
    case weekly
    case monthly
    case yearly 
    
    var startDate: Date {
        switch self {
        case .daily: .now.stripTime()
        case .weekly: Date.now.add(component: .day, value: -7)
        case .monthly: Date.now.add(component: .month, value: -1)
        case .yearly: Date.now.add(component: .year, value: -1)
        }
    }
    
    var title: String {
        switch self {
        case .daily: "Daily"
        case .weekly: "Weekly"
        case .monthly: "Monthly"
        case .yearly: "Yearly"
        }
    }
    
    var interval: DateInterval? {
        let calendar = Calendar.current
        
        switch self {
        case .daily:
            let start = Date.now.stripTime()
            let end = calendar.date(byAdding: .day, value: 1, to: start) ?? .now
            return DateInterval(start: start, end: end)
            
        case .weekly:  return calendar.dateInterval(of: .weekOfYear, for: .now)
        case .monthly: return calendar.dateInterval(of: .month, for: .now)
        case .yearly: return calendar.dateInterval(of: .year, for: .now)
        }
    }
}

//extension Int {
//    var frequencyEquivalent: Frequency {
//        
//    }
//}
