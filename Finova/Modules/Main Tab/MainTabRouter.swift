//
//  MainTabRouter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import UIKit
import Swinject

protocol MainTabRouter {
    var view: MainTabViewController? { get }
}

class MainTabRouterImpl: MainTabRouter {
    weak var view: MainTabViewController?
    
    func createHome(container: Resolver) -> UINavigationController {
        let home = container.resolve(HomeRouter.self)?.view
        return CustomNavigationController(rootViewController: home ?? UIViewController())
    }
    
    func createStatistics(container: Resolver) -> UINavigationController {
        let statistics = container.resolve(StatisticsRouter.self)?.view
        return UINavigationController(rootViewController: statistics ?? UIViewController())
    }
}
