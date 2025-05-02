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
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getPredefinedCategories() async -> [Category] {
        let viewContext = await coreDataStack.viewContext
        let testTransactionTypes = Category.getPredefinedTransactions(in: viewContext)
        
        return testTransactionTypes
    }
}
