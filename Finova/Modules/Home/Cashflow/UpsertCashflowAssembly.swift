//
//  UpsertCashflowAssembly.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import Foundation
import Swinject

class UpsertCashflowAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UpsertCashflowRouter.self) { (resolver, cashflowType: CashflowType) in
            let view = UpsertCashflowViewController(cashflowType: cashflowType)
            let interactor = UpsertCashflowInteractorImpl(
                accountService: resolver.resolve(AccountService.self)!,
                categoryService: resolver.resolve(CategoryService.self)!
            )
            let presenter = UpsertCashflowPresenterImpl()
            let router = UpsertCashflowRouterImpl()
            
            view.presenter = presenter
            
            interactor.presenter = presenter
            
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            
            router.upsertCashflowViewController = view
            return router
        }
    }
}
