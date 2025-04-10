//
//  StatisticsPresenter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import Foundation
import Swinject

protocol StatisticsPresenter: AnyObject {
    var router: StatisticsRouter? { get set }
    var interactor: StatisticsInteractor? { get set }
    var view: StatisticsView? { get set }
}

class StatisticsPresenterImpl: StatisticsPresenter {
    var router: (any StatisticsRouter)?
    var interactor: (any StatisticsInteractor)?
    weak var view: (any StatisticsView)?
}
