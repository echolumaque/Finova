//
//  HomeAssembly.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import Foundation
import Swinject

class HomeAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeRouter.self) { resolver in
            let view = HomeViewController(container: resolver)
            let interactor = HomeInteractorImpl(
                accountService: resolver.resolve(AccountService.self)!,
                coreDataStack: resolver.resolve(CoreDataStack.self)!,
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
