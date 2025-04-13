//
//  HomePresenter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import UIKit

protocol HomePresenter: AnyObject {
    var router: HomeRouter? { get set }
    var interactor: HomeInteractor? { get set }
    var view: HomeView? { get set }
    
    func getPredefinedAccounts() async
}

class HomePresenterImpl: HomePresenter {
    var router: (any HomeRouter)?
    var interactor: (any HomeInteractor)?
    weak var view: (any HomeView)?
    
    func getPredefinedAccounts() async {
        let predefinedAccounts = await interactor?.getPredefinedAccounts() ?? []
        view?.updateAccounts(predefinedAccounts)
    }
}
