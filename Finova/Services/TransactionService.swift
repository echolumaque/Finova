//
//  TransactionService.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/22/25.
//

import Foundation

actor TransactionService {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getPredefinedTransactions() async -> [Transaction] {
        let viewContext = await coreDataStack.viewContext
        let testTransactionTypes = TransactionType.getPredefinedTransactions(in: viewContext)
        let testTransactions = Transaction.getPredefinedTransactions(in: viewContext, type: testTransactionTypes)
        
        return testTransactions
    }
}
