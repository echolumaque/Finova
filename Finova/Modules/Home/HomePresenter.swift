//
//  HomePresenter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import CoreData
import UIKit

protocol HomePresenter: AnyObject {
    var router: HomeRouter? { get set }
    var interactor: HomeInteractor? { get set }
    var view: HomeView? { get set }
    
    func gotoAddCashflow(cashflowType: CashflowType)
    func fetchInitialTxns() async
    func updateTransactions(transactions: [TransactionCellViewModel])
    func getAccountsMenuData() async -> [UIAction]
    func getPrdefinedTransactions() async
}

class HomePresenterImpl: HomePresenter {
    var router: (any HomeRouter)?
    var interactor: (any HomeInteractor)?
    weak var view: (any HomeView)?
    
    private var accounts: [Account] = []
    private var selectedAccount: Account?
    
    func getAccountsMenuData() async -> [UIAction] {
        if accounts.isEmpty {
            let fetchedAccounts = await interactor?.getAccounts() ?? []
            accounts.append(contentsOf: fetchedAccounts)
            selectedAccount = fetchedAccounts.first
        }
        
        let actions = await MainActor.run {
            accounts.map { account in
                UIAction(title: account.name ?? "No account", state: selectedAccount == account ? .on : .off) { [weak self] _ in
                    guard let self else { return }
                    selectedAccount = account
                }
            }
        }
        
        return actions
    }
    
    func fetchInitialTxns() async {
        await interactor?.fetchInitialTxns()
    }
    
    func updateTransactions(transactions: [TransactionCellViewModel]) {
        view?.updateTransactions(transactions)
    }
    
    func getPrdefinedTransactions() async {
        let predefinedTransactions = await interactor?.getPrdefinedTransactions() ?? []
        view?.updateTransactions(predefinedTransactions.map { $0.convertToVm() })
    }
    
    func gotoAddCashflow(cashflowType: CashflowType) {
        router?.gotoAddCashflow(cashflowType: cashflowType)
    }
}
