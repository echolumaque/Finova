//
//  HomePresenter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import UIKit

protocol HomePresenter: AnyObject {
    var router: HomeRouter? { get set }
    var interactor: HomeInteractor? { get set }
    var view: HomeView? { get set }
    
    func gotoAddCashflow(cashflowType: CashflowType)
    func getPredefinedAccounts() async
    func getPrdefinedTransactions() async
}

class HomePresenterImpl: HomePresenter {
    var router: (any HomeRouter)?
    var interactor: (any HomeInteractor)?
    weak var view: (any HomeView)?
    
    func getPredefinedAccounts() async {
        let predefinedAccounts = await interactor?.getPredefinedAccounts() ?? []
        view?.updateAccounts(predefinedAccounts)
    }
    
    func getPrdefinedTransactions() async {
        let predefinedTransactions = await interactor?.getPrdefinedTransactions() ?? []
        view?.updateTransactions(predefinedTransactions)
    }
    
    func gotoAddCashflow(cashflowType: CashflowType) {
        router?.gotoAddCashflow(cashflowType: cashflowType)
    }
}
