//
//  CashflowPresenter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import Foundation

protocol CashflowPresenter: AnyObject {
    var router: CashflowRouter? { get set }
    var interactor: CashflowInteractor? { get set }
    var view: CashflowViewProtocol? { get set }
    
    func viewDidLoad()
    func selectAccount(_ account: Account)
    func selectCategory(_ category: Category)
}

class CashflowPresenterImpl: CashflowPresenter {
    var router: (any CashflowRouter)?
    var interactor: (any CashflowInteractor)?
    weak var view: CashflowViewProtocol?
    
    func viewDidLoad() {
        Task {
            let accounts = await interactor?.getAccounts() ?? []
            let categories = await interactor?.getCategories() ?? []
            await MainActor.run {
                view?.configureAccountMenuData(accounts)
                view?.configureCategories(categories)
            }
        }
    }
    
    func selectAccount(_ account: Account) {
        interactor?.selectAccount(account)
    }
    
    func selectCategory(_ category: Category) {
        interactor?.selectCategory(category)
    }
}
