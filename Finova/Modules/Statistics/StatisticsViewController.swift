//
//  StatisticsViewController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import UIKit
import Swinject

protocol StatisticsView: AnyObject {
    var presenter: StatisticsPresenter? { get set }
}

class StatisticsViewController: UIViewController, StatisticsView {
    let container: Resolver
    var presenter: StatisticsPresenter?
    
    init(container: Resolver) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
