//
//  UpsertCashflowInteractor.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import UIKit

protocol UpsertCashflowInteractor: AnyObject {
    var presenter: UpsertCashflowPresenter? { get set }
    
    func getAccounts() async -> [Account]
    func selectAccount(_ account: Account)
    
    func getCategories() async -> [Category]
    func selectCategory(_ category: Category)
    func loadImage(from provider: NSItemProvider) async throws -> UIImage
}

class UpsertCashflowInteractorImpl: UpsertCashflowInteractor {
    private let accountService: AccountService
    private let categoryService: CategoryService
    
    weak var presenter: (any UpsertCashflowPresenter)?
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
    
    func loadImage(from provider: NSItemProvider) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            provider.loadObject(ofClass: UIImage.self) { object, error in
                if let error { continuation.resume(throwing: error) }
                else if let image = object as? UIImage { continuation.resume(returning: image) }
                else {
                    continuation.resume(throwing: NSError(
                        domain: "UpsertCashflow",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "Unexpected object type"]
                    ))
                }
            }
        }
    }
}
