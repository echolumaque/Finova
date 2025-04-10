//
//  HomeInteractor.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import Foundation

protocol HomeInteractor: AnyObject {
    var presenter: HomePresenter? { get set }
}

class HomeInteractorImpl: HomeInteractor {
    weak var presenter: (any HomePresenter)?
}
