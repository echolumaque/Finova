//
//  DynamicLabel.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import UIKit

class DynamicLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(
        textColor: UIColor = .label,
        font: UIFont = UIFont.preferredFont(for: .body, weight: .regular),
        adjustsFontSizeToFitWidth: Bool = true,
        minimumScaleFactor: CGFloat = 1.0,
        numberOfLines: Int = 0
    ) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        self.font = font
        self.adjustsFontForContentSizeCategory = true
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        self.minimumScaleFactor = minimumScaleFactor
        self.numberOfLines = numberOfLines
    }
}

