//
//  BindableViewController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import Combine
import UIKit

class BindableViewController: UIViewController {
    var subscriptions = Set<AnyCancellable>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    func bindViewModel() { }
    
    func bind<P: Publisher>(_ publisher: P, action: @escaping (P.Output) -> Void) where P.Failure == Never {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: action)
            .store(in: &subscriptions)
    }
}

