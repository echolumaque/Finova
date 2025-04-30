//
//  CustomNavigationController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 5/1/25.
//

import UIKit

class CustomNavigationController: UINavigationController {
    // Return the visible child view controller which determines the status bar style.
    // Gives control of the status bar to its children VCs
    // More reference: https://developer.apple.com/documentation/technotes/tn3105-customizing-uistatusbar-syle
    override var childForStatusBarStyle: UIViewController? { visibleViewController }
}
