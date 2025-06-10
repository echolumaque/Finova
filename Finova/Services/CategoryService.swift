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
                
                let predefinedCategories: [(name: String, logo: String)] = [
                    ("Salary & Wages", "banknote.fill"),
                    ("Interest Income", "percent"),
                    ("Dividends", "chart.pie.fill"),
                    ("Refunds & Rebates", "arrow.uturn.left.circle.fill"),
                    ("Loan Proceeds", "building.columns.fill"),
                    ("Investment Gains", "chart.line.uptrend.xyaxis"),
                    ("Rental Income", "house.fill"),
                    ("Gift Received", "gift.fill"),
                    ("Tax Refund", "doc.text.fill"),
                    ("Reimbursements", "creditcard.fill"),
                    
                    ("Housing (Rent/Mortgage)", "house.fill"),
                    ("Utilities (Electric, Water, Internet)", "bolt.fill"),
                    ("Groceries & Household", "cart.fill"),
                    ("Transportation (Fuel, Public Transit)", "car.fill"),
                    ("Dining & Entertainment", "fork.knife"),
                    ("Healthcare & Insurance", "stethoscope"),
                    ("Education & Tuition", "book.fill"),
                    ("Subscriptions & Memberships", "repeat.circle.fill"),
                    ("Personal Care & Clothing", "tshirt.fill"),
                    ("Miscellaneous Shopping", "bag.fill")
                ]
                
                for (name, logo) in predefinedCategories {
                    let category = Category(context: context)
                    category.typeId = UUID()
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
