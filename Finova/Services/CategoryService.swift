//
//  CategoryService.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 5/2/25.
//

import CoreData
import Foundation

actor CategoryService {
    private let coreDataStack: CoreDataStack
    private var didInitialize = false
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func initializeService() async {
        guard !didInitialize else { return }
        didInitialize = true
        
        do {
            try await coreDataStack.performInBgContext { context in
                let request = Category.fetchRequest()
                request.resultType = .countResultType
                if try context.count(for: request) > 0 { return }
                
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
                
                for (name, cashflowType, logo) in predefinedCategories {
                    let category = Category(context: context)
                    category.typeId = UUID()
                    category.cashflowType = cashflowType.encode()
                    category.name = name
                    category.logo = logo
                }
                
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    func getCategories() async -> [Category] {
//        let viewContext = await coreDataStack.viewContext
//        let testTransactionTypes = Category.getPredefinedTransactions(in: viewContext)
//        
//        return testTransactionTypes
        
        let categories = try? await coreDataStack.performInMainContext { mainCtx in
            let request = Category.fetchRequest()
            return try? mainCtx.fetch(request)
        }
        
        return categories ?? []
    }
}
