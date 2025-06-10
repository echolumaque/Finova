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
        // Add any other app-wide configuration here
        return formatter
        
       
    }
    
    static func makeCurrencyFormatter(for currencyCode: String = "PHP") -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = Locale.current
        // You can add more configurations like locale
        return formatter
    }
}
