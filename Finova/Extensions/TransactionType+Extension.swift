//
//  TransactionType+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/22/25.
//

import Foundation
import CoreData

extension Category {
    convenience init(
        typeId: UUID,
        details: String,
        cashflowType: CashflowType,
        name: String,
        logo: String,
        in context: NSManagedObjectContext
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: context)!
        self.init(entity: entity, insertInto: context)
        self.typeId = typeId
        self.details = details
        self.cashflowType = cashflowType.encode()
        self.name = name
        self.logo = logo
    }
    
    static func getPredefinedTransactions(in context: NSManagedObjectContext) -> [Category] {
        // (name, description, cashflowType, sfSymbolName)
        let predefinedCategories: [(name: String, details: String, cashflowType: CashflowType, logo: String)] = [
            // Credit-only
            ("Salary & Wages",
             "Income earned from employment, including base salary, bonuses, commissions, and overtime.",
             .credit,
             "banknote.fill"),
            ("Interest Income",
             "Earnings from interest-bearing accounts and investments such as savings accounts, CDs, or bonds.",
             .credit,
             "percent"),
            ("Dividends",
             "Distributions received from stock holdings or mutual funds.",
             .credit,
             "chart.pie.fill"),
            ("Refunds & Rebates",
             "Money returned from purchases, returns, or promotional rebates.",
             .credit,
             "arrow.uturn.left.circle.fill"),
            ("Loan Proceeds",
             "Funds received when originating a new loan (e.g., personal, auto, or mortgage).",
             .credit,
             "building.columns.fill"),
            ("Investment Gains",
             "Profits realized from the sale of stocks, bonds, or other securities.",
             .credit,
             "chart.line.uptrend.xyaxis"),
            ("Rental Income",
             "Payments received from leasing residential or commercial property.",
             .credit,
             "house.fill"),
            ("Gift Received",
             "Monetary gifts received from friends, family, or other parties.",
             .credit,
             "gift.fill"),
            ("Tax Refund",
             "Payments returned by government agencies when you’ve overpaid taxes.",
             .credit,
             "doc.text.fill"),
            ("Reimbursements",
             "Repayments for expenses you paid on behalf of others or for work-related costs.",
             .credit,
             "creditcard.fill"),
            
            // Debit-only
            ("Housing (Rent/Mortgage)",
             "Payments for rent or mortgage obligations on residential or commercial property.",
             .debit,
             "house.fill"),
            ("Utilities (Electric, Water, Internet)",
             "Bills for essential services like electricity, water, gas, and Internet access.",
             .debit,
             "bolt.fill"),
            ("Groceries & Household",
             "Purchases of food, cleaning supplies, and other household necessities.",
             .debit,
             "cart.fill"),
            ("Transportation (Fuel, Public Transit)",
             "Fuel, public-transit fares, ride-shares, and basic vehicle maintenance.",
             .debit,
             "car.fill"),
            ("Dining & Entertainment",
             "Spending on restaurants, bars, movies, concerts, and other leisure activities.",
             .debit,
             "fork.knife"),
            ("Healthcare & Insurance",
             "Medical bills, prescription costs, and insurance premiums.",
             .debit,
             "stethoscope"),
            ("Education & Tuition",
             "Tuition payments, books, and fees for courses or training programs.",
             .debit,
             "book.fill"),
            ("Subscriptions & Memberships",
             "Recurring fees for streaming services, gyms, magazines, etc.",
             .debit,
             "repeat.circle.fill"),
            ("Personal Care & Clothing",
             "Grooming, cosmetics, apparel, and accessories.",
             .debit,
             "tshirt.fill"),
            ("Miscellaneous Shopping",
             "Discretionary spending on gifts, gadgets, or other non-essential items.",
             .debit,
             "bag.fill")
        ]
        
        return predefinedCategories.map { info in
            Category(
                typeId: UUID(),
                details: info.details,
                cashflowType: info.cashflowType,
                name: info.name,
                logo: info.logo,
                in: context
            )
        }.shuffled()
    }
}
