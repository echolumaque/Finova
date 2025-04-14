//
//  UIStackView+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/15/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views { addArrangedSubview(view) }
    }
}
