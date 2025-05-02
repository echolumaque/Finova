//
//  CashflowInteractor.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import Foundation

protocol CashflowInteractor: AnyObject {
    var presenter: CashflowPresenter? { get set }
    
    func getAccounts() async -> [Account]
    func selectAccount(_ account: Account)
    
    func getCategories() async -> [Category]
    func selectCategory(_ category: Category)
}

class CashflowInteractorImpl: CashflowInteractor {
    private let accountService: AccountService
    private let categoryService: CategoryService
    
    weak var presenter: (any CashflowPresenter)?
    private var selectedAccount: Account?
    private var selectedCategory: Category?
    
    init(accountService: AccountService, categoryService: CategoryService) {
        self.accountService = accountService
        self.categoryService = categoryService
    }
    
    func getAccounts() async -> [Account] {
        let accounts = await accountService.getPredefinedAccounts()
        if selectedAccount == nil { selectedAccount = accounts.first }
        
        return accounts
    }
    
    func selectAccount(_ account: Account) {
        selectedAccount = account
        print("selected account: \(account.name)")
    }
    
    func getCategories() async -> [Category] {
        let categories = await categoryService.getPredefinedCategories()
        if selectedCategory == nil { selectedCategory = categories.first }
        
        return categories
    }
    
    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
}
