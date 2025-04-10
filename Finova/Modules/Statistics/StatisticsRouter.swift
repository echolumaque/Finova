//
//  StatisticsRouter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import UIKit
import Swinject

typealias StatisticsEntryPoint = StatisticsView & UIViewController

protocol StatisticsRouter {
    var view: StatisticsEntryPoint? { get }
}

class StatisticsRouterImpl: StatisticsRouter {
    let container: Resolver
    var statisticsViewController: StatisticsEntryPoint?
    weak var view: (any StatisticsEntryPoint)? { statisticsViewController }
    
    init(container: Resolver) {
        self.container = container
    }
}
