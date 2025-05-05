//
//  CashflowType.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/14/25.
//

import UIKit

enum CashflowType: String, Codable, CaseIterable {
    case credit = "Credit"
    case debit = "Debit"
    
    var color: UIColor {
        switch self {
        case .credit: UIColor(rgb: 0x4BA570)
        case .debit: UIColor(rgb: 0xE94E51)
        }
    }
    
    var imageToUse: UIImage {
        UIImage(resource: self == .credit ? .customBanknoteSealFillBadgePlus : .customBanknoteSealFillBadgeMinus)
    }
    
    var operatorToUse: String {
        switch self {
        case .credit: "+"
        case .debit: "-"
        }
    }
}
