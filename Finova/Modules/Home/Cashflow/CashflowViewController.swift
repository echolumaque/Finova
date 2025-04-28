//
//  CashflowViewController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import Swinject
import UIKit

protocol CashflowViewProtocol: AnyObject {
    var presenter: CashflowPresenter? { get set }
}

class CashflowViewController: UIViewController, CashflowViewProtocol {
    var presenter: CashflowPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
