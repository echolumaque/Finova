//
//  UpsertCashflowRouter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import UIKit
import Swinject

typealias UpsertCashflowEntryPoint = UpsertCashflowViewProtocol & UIViewController

protocol UpsertCashflowRouter: AnyObject {
    var view: UpsertCashflowEntryPoint? { get }
}

class UpsertCashflowRouterImpl: UpsertCashflowRouter {
    weak var view: UpsertCashflowEntryPoint? { upsertCashflowViewController }
    var upsertCashflowViewController: UpsertCashflowEntryPoint?
}
