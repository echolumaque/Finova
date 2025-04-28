//
//  CashflowInteractor.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import Foundation

protocol CashflowInteractor: AnyObject {
    var presenter: CashflowPresenter? { get set }
}

class CashflowInteractorImpl: CashflowInteractor {
    weak var presenter: (any CashflowPresenter)?
}
