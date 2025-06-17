//
//  TransactionService.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/22/25.
//

import CoreData
import Foundation
import RxSwift
import UIKit

actor TransactionService {
    private let coreDataStack: CoreDataStack
    
    private let txnsUpdatedSubject = BehaviorSubject<Transaction?>(value: nil)
    var txnsUpdated: Observable<Transaction?> { txnsUpdatedSubject.asObservable() }
    
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
    
    func fetchInitialTxns(onAccount: Account) async -> [Transaction] {
        do {
            let txns = try await coreDataStack.performInMainContext { ctx in
                let fetchRequest = Transaction.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "account == %@", onAccount)
                return try ctx.fetch(fetchRequest)
            }
            
            return txns
        } catch {
            print("Error happened in fetchAllTxns: \(error)")
            return []
        }
    }
    
    func upsertTxn(
        transaction: Transaction? = nil,
        account: Account,
        category: Category,
        cashflowType: CashflowType,
        value: Double,
        desc: String,
        attachment: Data?
    ) async {
        do {
            let upsertedObjId = try await coreDataStack.performInBgContext { bgContext in
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
                txnInCtx.cashflowType = cashflowType.encode()
                txnInCtx.value = value
                txnInCtx.desc = desc.trimmingCharacters(in: .whitespacesAndNewlines)
                txnInCtx.attachment = attachment
                
                try bgContext.save()
                return txnInCtx.objectID
            }
            
            let upsertedTxn = try await coreDataStack.performInMainContext { context in
                try? context.existingObject(with: upsertedObjId) as? Transaction
            }
            
            txnsUpdatedSubject.onNext(upsertedTxn)
        } catch {
            print("Error happened in upsertTransaction: \(error)")
            txnsUpdatedSubject.onError(error)
        }
    }
}
