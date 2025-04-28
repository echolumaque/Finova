//
//  CashflowRouter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import UIKit
import Swinject

typealias CashflowEntryPoint = CashflowViewProtocol & UIViewController

protocol CashflowRouter: AnyObject {
    var view: CashflowEntryPoint? { get }
}

class CashflowRouterImpl: CashflowRouter {
    weak var view: CashflowEntryPoint? { cashflowViewController }
    var cashflowViewController: CashflowEntryPoint?
}
