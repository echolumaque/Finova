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
}

class HomeInteractorImpl: HomeInteractor {
    weak var presenter: (any HomePresenter)?
    
    private let accountService: AccountService
    
    init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    func getPredefinedAccounts() async -> [Account] {
        let predefinedAccounts = await accountService.getPredefinedAccounts()
        return predefinedAccounts
    }
}
