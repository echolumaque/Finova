//
//  CashflowAssembly.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import Foundation
import Swinject

class CashflowAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CashflowRouter.self) { (resolver, cashflowType: CashflowType) in
            let view = CashflowViewController(cashflowType: cashflowType)
            let interactor = CashflowInteractorImpl(
                accountService: resolver.resolve(AccountService.self)!,
                categoryService: resolver.resolve(CategoryService.self)!
            )
            let presenter = CashflowPresenterImpl()
            let router = CashflowRouterImpl()
            
            view.presenter = presenter
            
            interactor.presenter = presenter
            
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            
            router.cashflowViewController = view
            return router
        }
    }
}

/*
 class HomeAssembly: Assembly {
     func assemble(container: Container) {
         container.register(HomeRouter.self) { resolver in
             let view = HomeViewController(container: resolver)
             let interactor = HomeInteractorImpl(
                 accountService: resolver.resolve(AccountService.self)!,
                 transactionService: resolver.resolve(TransactionService.self)!
             )
             let presenter = HomePresenterImpl()
             let router = HomeRouterImpl(container: resolver)
             
             view.presenter = presenter
 //            view.navigationItem.title = "Home"
             view.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
             
             interactor.presenter = presenter
             
             presenter.router = router
             presenter.view = view
             presenter.interactor = interactor
             
             router.homeViewController = view
             return router
         }
     }
 }

 */
