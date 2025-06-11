//
//  FormatterFactory.swift
//  Finova
//
//  Created by Jhericoh Lumaque on 6/10/25.
//

import Foundation

enum FormatterFactory {
    static func makeDecimalFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2 // e.g., "1,234" instead of "1,234.00"
        
        return formatter
    }
    
    static func makeCurrencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        let locale = Locale.current
        
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.currencySymbol = locale.currencySymbol ?? "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2 // e.g., "1,234" instead of "1,234.00"
        
        return formatter
    }
}
