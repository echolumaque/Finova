//
//  HomeInteractor.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import Foundation

protocol HomeInteractor: AnyObject {
    var presenter: HomePresenter? { get set }
    func getPredefinedAccounts() async -> [Account]
    func getPrdefinedTransactions() async -> [Transaction]
}

class HomeInteractorImpl: HomeInteractor {
    weak var presenter: (any HomePresenter)?
    
    private let accountService: AccountService
    private let transactionService: TransactionService
    
    init(accountService: AccountService, transactionService: TransactionService) {
        self.accountService = accountService
        self.transactionService = transactionService
    }
    
    func getPredefinedAccounts() async -> [Account] {
        let predefinedAccounts = await accountService.getPredefinedAccounts()
        return predefinedAccounts
    }
    
    func getPrdefinedTransactions() async -> [Transaction] {
        let predefinedTransactions = await transactionService.getPredefinedTransactions()
        return predefinedTransactions
    }
}
