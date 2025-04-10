//
//  HomeRouter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import UIKit
import Swinject

typealias HomeEntryPoint = HomeView & UIViewController

protocol HomeRouter {
    var view: HomeEntryPoint? { get }
}

class HomeRouterImpl: HomeRouter {
    let container: Resolver
    var homeViewController: HomeEntryPoint?
    weak var view: HomeEntryPoint? { homeViewController }
    
    init(container: Resolver) {
        self.container = container
    }
}
