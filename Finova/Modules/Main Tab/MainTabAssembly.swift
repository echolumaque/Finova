//
//  MainTabAssembly.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import Foundation
import Swinject

class MainTabAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MainTabRouter.self) { resolver in
            let view = MainTabViewController()
            let router = MainTabRouterImpl()
            view.viewControllers = [
                router.createHome(container: resolver),
                router.createStatistics(container: resolver)
            ]
            
            router.view = view
            
            return router
        }
    }
}
