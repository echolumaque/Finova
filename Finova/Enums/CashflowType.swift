//
//  CashflowType.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/14/25.
//

import UIKit

enum CashflowType: String, CaseIterable {
    case income = "Income"
    case expense = "Expenses"
    
    var color: UIColor {
        UIColor(rgb: self == .income ? 0x4BA570 : 0xE94E51)
    }
    
    var imageToUse: UIImage {
        UIImage(resource: self == .income ? .customBanknoteSealFillBadgePlus : .customBanknoteSealFillBadgeMinus)
    }
}
