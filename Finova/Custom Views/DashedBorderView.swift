//
//  DashedBorderView.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/30/25.
//

import UIKit

class DashedBorderView: UIView {
    private var color: UIColor = .clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init(color: UIColor,
                     lineWidth: CGFloat = 1,
                     dashPattern: [NSNumber] = [6, 3]) {
        self.init(frame: .zero)
        self.color = color
        addDashedBorder(color: color, lineWidth: lineWidth, dashPattern: dashPattern)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedBorder(color: color, lineWidth: 1, dashPattern: [6, 3])
    }
    
    private func addDashedBorder(color: UIColor,
                                 lineWidth: CGFloat = 0.5,
                                 dashPattern: [NSNumber] = [6, 3]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Remove any existing dashed border
        layer.sublayers?
            .filter { $0.name == "DashedBorder" }
            .forEach { $0.removeFromSuperlayer() }
        
        let dash = CAShapeLayer()
        dash.name = "DashedBorder"
        dash.bounds = bounds
        dash.position = CGPoint(x: bounds.midX, y: bounds.midY)
        dash.fillColor = UIColor.clear.cgColor
        dash.strokeColor = color.cgColor
        dash.lineWidth = lineWidth
        dash.lineDashPattern = dashPattern
        dash.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
        layer.addSublayer(dash)
    }
}
