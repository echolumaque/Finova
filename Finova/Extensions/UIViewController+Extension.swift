//
//  UIViewController+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/30/25.
//

import UIKit

extension UIViewController {
    func textFieldToolbar(doneHandler: @escaping () -> ()) -> UIToolbar {
        let screenWidth: CGFloat = view.window?.windowScene?.screen.bounds.width ?? UIScreen.main.bounds.width
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        toolBar.autoresizingMask = [.flexibleWidth]
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.isUserInteractionEnabled = true
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneAction = UIAction { [weak self] _ in
            self?.view.endEditing(true)
            doneHandler()
        }
        let doneButton = UIBarButtonItem(systemItem: .done, primaryAction: doneAction)
        toolBar.setItems([space, doneButton], animated: false)
        
        return toolBar
    }
}
