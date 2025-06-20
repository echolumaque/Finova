//
//  HomeInteractor.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import CoreData
import Foundation
import RxSwift

protocol HomeInteractor: AnyObject {
    var presenter: HomePresenter? { get set }
    var accountValueUpdated: Observable<(Account?, Double)>? { get }
    var upsertedTxns: Observable<Transaction?>? { get }
    
    func getAccounts() async -> [Account]
    func getTransactionsOn(account: Account, frequency: Frequency) async -> [TransactionCellViewModel]
    func getPrdefinedTransactions() async -> [Transaction]
//    func getTxnsFrom(account: Account) async -> [TransactionCellViewModel]
}

class HomeInteractorImpl: HomeInteractor {
    weak var presenter: (any HomePresenter)?
    var accountValueUpdated: Observable<(Account?, Double)>?
    var upsertedTxns: Observable<Transaction?>?
    
    private let accountService: AccountService
    private let coreDataStack: CoreDataStack
    private let transactionService: TransactionService
    private lazy var numberFormatter = FormatterFactory.makeCurrencyFormatter()
    
    init(
        accountService: AccountService,
        coreDataStack: CoreDataStack,
        transactionService: TransactionService
    ) {
        self.accountService = accountService
        self.coreDataStack = coreDataStack
        self.transactionService = transactionService
        
        subscribeToAccountUpdates()
        subscribeToTxnUpserts()
    }
    
    func getAccounts() async -> [Account] {
        let accounts = await accountService.getAccounts()
        return accounts
    }
    
    func getTransactionsOn(account: Account, frequency: Frequency) async -> [TransactionCellViewModel] {
        let txns = await transactionService.getTransactionsOn(account: account, frequency: frequency)
        let parsedTxns = txns.map { txn in
            let formattedValue = "\(numberFormatter.string(from: NSNumber(floatLiteral: txn.value)) ?? "0")"
            return txn.convertToVm(formattedValue: formattedValue)
        }
        
        return parsedTxns
    }
    
    func getPrdefinedTransactions() async -> [Transaction] {
        let predefinedTransactions = await transactionService.getPredefinedTransactions()
        return predefinedTransactions
    }
    
//    func getTxnsFrom(account: Account) async -> [TransactionCellViewModel] {
//        let txns = await accountService.getTxnsFrom(account: account)
//        let parsedTxns = txns.map { txn in
//            let formattedValue = "\(numberFormatter.string(from: NSNumber(floatLiteral: txn.value)) ?? "0")"
//            return txn.convertToVm(formattedValue: formattedValue)
//        }
//        
//        return parsedTxns
//    }
    
    private func subscribeToAccountUpdates() {
        Task {
            accountValueUpdated = await accountService
                .accountValueUpdated
                .share(replay: 1)
        }
    }
    
    private func subscribeToTxnUpserts() {
        // Invoked when a transaction is upserted
        Task {
            upsertedTxns = await transactionService
                .txnsUpdated
                .compactMap { $0 }
                .share(replay: 1)
        }
    }
}
