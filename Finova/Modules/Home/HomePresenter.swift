//
//  HomePresenter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import CoreData
import RxSwift
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
    private let disposeBag = DisposeBag()
    private var selectedAccount: Account?
    private let selectedAccountUpdatedSubject = PublishSubject<Account>()
    
    init() {
        subscribeToAccountChanges()
    }
    
    func getAccountsMenuData() async -> [UIAction] {
        let actions = await MainActor.run {
            accounts.map { account in
                UIAction(title: account.name ?? "No account", state: selectedAccount == account ? .on : .off) { [weak self] _ in
                    guard let self else { return }
                    selectedAccount = account
                    selectedAccountUpdatedSubject.onNext(account)
                }
            }
        }
        
        return actions
    }
    
    func fetchInitialTxns() async {
        let fetchedAccounts = await interactor?.getAccounts() ?? []
        accounts.append(contentsOf: fetchedAccounts)
        selectedAccount = fetchedAccounts.first
        
        guard let selectedAccount else { return }
        await interactor?.fetchInitialTxns(onAccount: selectedAccount)
    }
    
    func updateTransactions(transactions: [TransactionCellViewModel]) {
        view?.updateTxns(transactions)
    }
    
    func getPrdefinedTransactions() async {
        let predefinedTransactions = await interactor?.getPrdefinedTransactions() ?? []
        view?.updateTxns(predefinedTransactions.map { $0.convertToVm() })
    }
    
    func gotoAddCashflow(cashflowType: CashflowType) {
        router?.gotoAddCashflow(cashflowType: cashflowType)
    }
    
    private func subscribeToAccountChanges() {
        _ = selectedAccountUpdatedSubject.subscribe { event in
            switch event {
            case .next(let account):
                Task { [weak self] in
                    guard let self else { return }
                    
                    let txns = await interactor?.getTxnsFrom(account: account) ?? []
                    view?.updateTxnsBasedOnAccount(txns)
                }
                
            case .error(_): break
            case .completed: break
            }
        }
        .disposed(by: disposeBag)
    }
}
