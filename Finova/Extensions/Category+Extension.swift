//
//  Category+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/22/25.
//

import Foundation
import CoreData

extension Category {
    convenience init(
        typeId: UUID,
        name: String,
        logo: String,
        in context: NSManagedObjectContext
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: context)!
        self.init(entity: entity, insertInto: context)
        self.typeId = typeId
        self.name = name
        self.logo = logo
    }
    
    static func getPredefinedTransactions(in context: NSManagedObjectContext) -> [Category] {
        // (name, description, cashflowType, sfSymbolName)
        let predefinedCategories: [(name: String, cashflowType: CashflowType, logo: String)] = [
            // Credit-only
            ("Salary & Wages",
             .credit,
             "banknote.fill"),
            ("Interest Income",
             .credit,
             "percent"),
            ("Dividends",
             .credit,
             "chart.pie.fill"),
            ("Refunds & Rebates",
             .credit,
             "arrow.uturn.left.circle.fill"),
            ("Loan Proceeds",
             .credit,
             "building.columns.fill"),
            ("Investment Gains",
             .credit,
             "chart.line.uptrend.xyaxis"),
            ("Rental Income",
             .credit,
             "house.fill"),
            ("Gift Received",
             .credit,
             "gift.fill"),
            ("Tax Refund",
             .credit,
             "doc.text.fill"),
            ("Reimbursements",
             .credit,
             "creditcard.fill"),
            
            // Debit-only
            ("Housing (Rent/Mortgage)",
             .debit,
             "house.fill"),
            ("Utilities (Electric, Water, Internet)",
             .debit,
             "bolt.fill"),
            ("Groceries & Household",
             .debit,
             "cart.fill"),
            ("Transportation (Fuel, Public Transit)",
             .debit,
             "car.fill"),
            ("Dining & Entertainment",
             .debit,
             "fork.knife"),
            ("Healthcare & Insurance",
             .debit,
             "stethoscope"),
            ("Education & Tuition",
             .debit,
             "book.fill"),
            ("Subscriptions & Memberships",
             .debit,
             "repeat.circle.fill"),
            ("Personal Care & Clothing",
             .debit,
             "tshirt.fill"),
            ("Miscellaneous Shopping",
             .debit,
             "bag.fill")
        ]
        
        return predefinedCategories.map { info in
            Category(
                typeId: UUID(),
                name: info.name,
                logo: info.logo,
                in: context
            )
        }.shuffled()
    }
}

extension Category {
    var sampleDescriptions: [String] {
        switch name {
        case "Salary & Wages": return ["Monthly salary payment", "Bi-weekly paycheck"]
        case "Interest Income": return ["Savings account interest", "CD dividend payout"]
        case "Dividends": return ["Quarterly dividend", "ETF dividend distribution"]
        case "Refunds & Rebates": return ["Product refund", "Tax rebate credit"]
        case "Loan Proceeds": return ["Personal loan received", "Line-of-credit advance"]
        case "Investment Gains": return ["Stock sale profit", "Crypto trade gain"]
        case "Rental Income": return ["April rent", "Lease payment"]
        case "Gift Received": return ["Birthday gift", "Anniversary gift"]
        case "Tax Refund": return ["IRS refund", "State tax refund"]
        case "Reimbursements": return ["Expense reimbursement", "Travel cost paid back"]
            
        case "Housing (Rent/Mortgage)": return ["Monthly rent", "Mortgage payment"]
        case "Utilities (Electric, Water, Internet)": return ["Electric bill", "Water bill", "Internet subscription"]
        case "Groceries & Household": return ["Grocery store",  "Supermarket run"]
        case "Transportation (Fuel, Public Transit)": return ["Gas station", "Bus fare"]
        case "Dining & Entertainment": return ["Restaurant dinner", "Movie tickets"]
        case "Healthcare & Insurance": return ["Doctor’s visit", "Health insurance premium"]
        case "Education & Tuition": return ["Semester tuition", "Online course fee"]
        case "Subscriptions & Memberships": return ["Streaming service", "Gym membership"]
        case "Personal Care & Clothing": return ["Clothing purchase", "Salon visit"]
        case "Miscellaneous Shopping": return ["Mall shopping", "Online order"]
            
        default:
            return [name ?? "Unavailable"]
        }
    }
    
    /// Pick one of the sample descriptions at random.
    func randomDescription() -> String {
        sampleDescriptions.randomElement() ?? name ?? "Unavailable"
    }
}
