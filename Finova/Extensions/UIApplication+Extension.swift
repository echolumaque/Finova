//
//  UIApplication+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import UIKit

extension UIApplication {
    /// Returns the topmost view controller in the app's window hierarchy.
    /// - Parameter base: start from this view controller; by default uses the key window's root.
    class func topViewController(
        base: UIViewController? = {
            // iOS 13+: find the active foreground scene's key window
            if #available(iOS 13, *) {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first { $0.isKeyWindow }?
            .rootViewController
    }
            // Fallback on earlier iOS
            return UIApplication.shared.keyWindow?.rootViewController
        }()
    ) -> UIViewController? {
        guard let viewController = base else { return nil }
        
        switch viewController {
        case let presenting where presenting.presentedViewController != nil:
            return topViewController(base: presenting.presentedViewController)
            
        case let navigation as UINavigationController:
            return topViewController(base: navigation.visibleViewController)
            
        case let tab as UITabBarController:
            return topViewController(base: tab.selectedViewController)
            
        case let page as UIPageViewController:
            return topViewController(base: page.viewControllers?.first)
            
        default:
            return viewController
        }
    }
}
