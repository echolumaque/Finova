//
//  UpsertCashflowPresenter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import Foundation

protocol UpsertCashflowPresenter: AnyObject {
    var router: UpsertCashflowRouter? { get set }
    var interactor: UpsertCashflowInteractor? { get set }
    var view: UpsertCashflowViewProtocol? { get set }
    
    func viewDidLoad()
    func validateValueIfDecimal(value: String) -> Bool
    func selectAccount(_ account: Account)
    func selectCategory(_ category: Category)
    func getCameraController() async -> CameraController?
}

class UpsertCashflowPresenterImpl: UpsertCashflowPresenter {
    var router: (any UpsertCashflowRouter)?
    var interactor: (any UpsertCashflowInteractor)?
    weak var view: UpsertCashflowViewProtocol?
    
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
    
    func validateValueIfDecimal(value: String) -> Bool {
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let separatorEscaped = NSRegularExpression.escapedPattern(for: decimalSeparator)
        let pattern = "^\\d*(?:\(separatorEscaped)\\d{0,2})?$"
        
        return value.range(of: pattern, options: .regularExpression) != nil
    }
    
    func selectAccount(_ account: Account) {
        interactor?.selectAccount(account)
    }
    
    func selectCategory(_ category: Category) {
        interactor?.selectCategory(category)
    }
    
    func getCameraController() async -> CameraController? {
        let isAuthorized = await CameraController.checkCameraAuthorizationStatus()
        return await isAuthorized ? CameraController() : nil
    }
}
