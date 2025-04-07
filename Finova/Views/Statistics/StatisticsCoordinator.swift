//
//  StatisticsCoordinator.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import UIKit

class StatisticsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var viewController: UIViewController!
    var onFinished: (() -> Void)?
    
    func start() {
        let viewController = StatisticsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(systemName: "chart.xyaxis.line"), tag: 1)
        self.viewController = viewController
    }
}
