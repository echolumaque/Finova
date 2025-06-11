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
    func getAccounts() async
    func getPrdefinedTransactions() async
}

class HomePresenterImpl: HomePresenter {
    var router: (any HomeRouter)?
    var interactor: (any HomeInteractor)?
    weak var view: (any HomeView)?
    
    private var items: [Transaction] = []
    private var hasDoneInitialLoad = false
    
    func getAccounts() async {
        let accounts = await interactor?.getAccounts() ?? []
        view?.updateAccounts(accounts)
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
