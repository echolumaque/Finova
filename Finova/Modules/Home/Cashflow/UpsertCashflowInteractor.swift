//
//  UpsertCashflowInteractor.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import UIKit

protocol UpsertCashflowInteractor: AnyObject {
    var presenter: UpsertCashflowPresenter? { get set }
    
    func didFinishedEnteringValue(_ value: String)
    
    func getAccounts() async -> [Account]
    func selectAccount(_ account: Account)
    
    func getCategories() async -> [Category]
    func selectCategory(_ category: Category)
    
    func didFinishedEnteringDescription(_ description: String)
    
    func selectAttachment(_ attachment: UIImage)
    
    func loadImage(from provider: NSItemProvider) async throws -> UIImage
    func upsertTransaction(cashflowType: CashflowType) async
}

class UpsertCashflowInteractorImpl: UpsertCashflowInteractor {
    private let accountService: AccountService
    private let categoryService: CategoryService
    private let transactionService: TransactionService
    
    weak var presenter: (any UpsertCashflowPresenter)?
    private var selectedAccount: Account?
    private var selectedCategory: Category?
    private var value: Double = 0.0
    private var description: String = ""
    private var selectedAttachment: Data?
    
    init(
        accountService: AccountService,
        categoryService: CategoryService,
        transactionService: TransactionService
    ) {
        self.accountService = accountService
        self.categoryService = categoryService
        self.transactionService = transactionService
    }
    
    func didFinishedEnteringValue(_ value: String) {
        self.value = Double(value) ?? .zero
    }
    
    func getAccounts() async -> [Account] {
        let accounts = await accountService.getAccounts()
        if selectedAccount == nil { selectedAccount = accounts.first }
        
        return accounts
    }
    
    func selectAccount(_ account: Account) {
        selectedAccount = account
    }
    
    func getCategories() async -> [Category] {
        let categories = await categoryService.getCategories()
        if selectedCategory == nil { selectedCategory = categories.first }
        
        return categories
    }
    
    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    func didFinishedEnteringDescription(_ description: String) {
        self.description = description
    }
    
    func selectAttachment(_ attachment: UIImage) {
        selectedAttachment = attachment.heicData() ?? attachment.jpegData(compressionQuality: 0.8)
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
    
    func upsertTransaction(cashflowType: CashflowType) async {
        guard let selectedAccount, let selectedCategory else { return }
        
        let valueEntry: TransactionType = cashflowType == .credit ? .credit(value: value) : .debit(value: value)
        await transactionService.upsertTxn(
            transaction: nil,
            account: selectedAccount,
            category: selectedCategory,
            cashflowType: cashflowType,
            value: value,
            desc: description,
            attachment: selectedAttachment
        )
        await accountService.accountValueUpdatedSubject.onNext((selectedAccount, valueEntry))
    }
}
