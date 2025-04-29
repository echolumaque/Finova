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
    func gotoAddCashflow(cashflowType: CashflowType)
}

class HomeRouterImpl: HomeRouter {
    let container: Resolver
    var homeViewController: HomeEntryPoint?
    weak var view: HomeEntryPoint? { homeViewController }
    
    init(container: Resolver) {
        self.container = container
    }
    
    func gotoAddCashflow(cashflowType: CashflowType) {
        let cashflowView = container.resolve(CashflowRouter.self, argument: cashflowType)?.view as? UIViewController
        homeViewController?.navigationController?.pushViewController(cashflowView ?? UIViewController(), animated: true)
    }
}
