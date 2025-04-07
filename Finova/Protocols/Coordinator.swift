//
//  Coordinator.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
    var onFinished: (() -> Void)? { get set }
}
