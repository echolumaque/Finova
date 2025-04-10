//
//  StatisticsInteractor.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import Foundation
import Swinject

protocol StatisticsInteractor: AnyObject {
    var presenter: StatisticsPresenter? { get set }
}

class StatisticsInteractorImpl: StatisticsInteractor {
    weak var presenter: (any StatisticsPresenter)?
}
