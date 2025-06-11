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
    func getAccounts() async -> [Account]
    func fetchInitialTxns() async
    func getTransactions() async -> [Transaction]
    func getPrdefinedTransactions() async -> [Transaction]
}

class HomeInteractorImpl: HomeInteractor {
    weak var presenter: (any HomePresenter)?
    
    private let accountService: AccountService
    private let coreDataStack: CoreDataStack
    private let disposeBag = DisposeBag()
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
        
        subscribeToTransactionUpdates()
    }
    
    func getAccounts() async -> [Account] {
        let accounts = await accountService.getAccounts()
        return accounts
    }
    
    func fetchInitialTxns() async {
        let txns = await transactionService.fetchAllTxns()
        let mappedVm = txns.map { txn in
            let formattedValue = "\(numberFormatter.string(from: NSNumber(floatLiteral: txn.value)) ?? "0")"
            return txn.convertToVm(formattedValue: formattedValue)
        }
        
        presenter?.updateTransactions(transactions: mappedVm)
    }
    
    func getTransactions() async -> [Transaction] {
        let transactions = await transactionService.getTransactionsOn()
        return transactions
    }
    
    func getPrdefinedTransactions() async -> [Transaction] {
        let predefinedTransactions = await transactionService.getPredefinedTransactions()
        return predefinedTransactions
    }
    
    private func subscribeToTransactionUpdates() {
        Task {
            await transactionService.txnsUpdated
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] txn in
                    guard let self, let txn else { return }
                    
                    let formattedValue = "\(numberFormatter.string(from: NSNumber(floatLiteral: txn.value)) ?? "0")"
                    presenter?.updateTransactions(transactions: [txn.convertToVm(formattedValue: formattedValue)])
                })
                .disposed(by: disposeBag)
        }
    }
}
