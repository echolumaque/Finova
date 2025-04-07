//
//  HomeCoordinator.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import UIKit

class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var viewController: UIViewController!
    var onFinished: (() -> Void)?
    
    func start() {
        let viewController = HomeViewController()
        viewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        self.viewController = viewController
    }
}
