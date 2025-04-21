//
//  UIView+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import UIKit

extension UIView {
    enum GradientDirection {
        case leftToRight
        case topToBottom
        case topLeftToBottomRight
        case topRightToBottomLeft
        
        var startPoint: CGPoint {
            switch self {
            case .leftToRight:
                return CGPoint(x: 0, y: 0.5)
            case .topToBottom:
                return CGPoint(x: 0.5, y: 0)
            case .topLeftToBottomRight:
                return CGPoint(x: 0, y: 0)
            case .topRightToBottomLeft:
                return CGPoint(x: 1, y: 0)
            }
        }
        
        var endPoint: CGPoint {
            switch self {
            case .leftToRight:
                return CGPoint(x: 1, y: 0.5)
            case .topToBottom:
                return CGPoint(x: 0.5, y: 1)
            case .topLeftToBottomRight:
                return CGPoint(x: 1, y: 1)
            case .topRightToBottomLeft:
                return CGPoint(x: 0, y: 1)
            }
        }
    }
    
    func pinToEdges(of superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
    
    /// Applies a gradient background to the view.
    /// - Parameters:
    ///   - colors: An array of UIColor for the gradient.
    ///   - direction: The desired gradient direction.
    func applyGradient(colors: [UIColor],
                       direction: GradientDirection = .topToBottom) {
        // Remove any existing gradient layers if needed (optional)
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        // Create a gradient layer.
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        
        // Set the gradient direction.
        gradientLayer.startPoint = direction.startPoint
        gradientLayer.endPoint = direction.endPoint
        
        // Set the frame to cover the entire view.
        gradientLayer.frame = bounds
        
        // Make sure it auto-resizes with the view.
//        gradientLayer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Insert at the bottom so that any subviews appear above the gradient.
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
