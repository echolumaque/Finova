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
        let testTransactionTypes = Category.getPredefinedTransactions(in: viewContext)
        let testTransactions = Transaction.getPredefinedTransactions(in: viewContext, categories: testTransactionTypes)
        
        return testTransactions
    }
    
    func getTransactionsOn(/*timePeriod: Frequency*/) async -> [Transaction] {
        do {
            let fetchRequest = Transaction.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "date == %@", Date.now as NSDate)
            let transactions = try await coreDataStack.performInMainContext { mainContext in
                try mainContext.fetch(fetchRequest)
            }
            
            return transactions
        } catch {
            return []
        }
    }
    
    func upsertTransaction(
        transaction: Transaction? = nil,
        account: Account,
        category: Category,
        value: Double,
        desc: String
    ) async {
        do {
            try await coreDataStack.performInBgContext { bgContext in
                var txnInCtx: Transaction
                if let transaction, let fetchedTxn = try bgContext.existingObject(with: transaction.objectID) as? Transaction {
                    txnInCtx = fetchedTxn
                } else {
                    txnInCtx = Transaction(context: bgContext)
                    txnInCtx.txnId = UUID()
                    txnInCtx.date = .now
                }
                
                txnInCtx.account = try bgContext.existingObject(with: account.objectID) as? Account
                txnInCtx.category = try bgContext.existingObject(with: category.objectID) as? Category
                txnInCtx.value = value
                txnInCtx.desc = desc
            }
        } catch {
            
        }
    }
}
