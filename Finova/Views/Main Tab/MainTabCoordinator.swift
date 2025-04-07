//
//  MainTabCoordinator.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import Combine
import Foundation
import Swinject

class MainTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var rootViewController = UINavigationController()
    var onFinished: (() -> Void)?
    
    func start() {
        let mainTab = MainTabViewController()
        mainTab.viewControllers = [createHomeTab(), createStatisticsTab()]
        
        rootViewController = UINavigationController(rootViewController: mainTab)
    }
    
    private func createHomeTab() -> UIViewController {
        let homeCoordinator = HomeCoordinator()
        homeCoordinator.start()
        return homeCoordinator.viewController
    }
    
    private func createStatisticsTab() -> UIViewController {
        let statisticsCoordinator = StatisticsCoordinator()
        statisticsCoordinator.start()
        return statisticsCoordinator.viewController
    }
}
