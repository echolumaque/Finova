//
//  StatisticsAssembly.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import Foundation
import Swinject

class StatisticsAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StatisticsRouter.self) { resolver in
            let view = StatisticsViewController(container: resolver)
            let interactor = StatisticsInteractorImpl()
            let presenter = StatisticsPresenterImpl()
            let router = StatisticsRouterImpl(container: resolver)
            
            view.presenter = presenter
            view.navigationItem.title = "Statistics"
            view.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(systemName: "chart.xyaxis.line"), tag: 1)
            
            interactor.presenter = presenter
            
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            
            router.statisticsViewController = view
            return router
        }
    }
}
