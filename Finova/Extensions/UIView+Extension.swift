//
//  UIView+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import SnapKit
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
    
    func pinToEdges(
        of superView: UIView,
        shouldUseSafeAreaHorizontal: Bool = false,
        shouldUseSafeAreaVertical: Bool = false
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            switch (shouldUseSafeAreaHorizontal, shouldUseSafeAreaVertical) {
            case (true, true):
                make.edges.equalToSuperview { $0.safeAreaLayoutGuide }
                
            case (true, false):
                make.horizontalEdges.equalToSuperview { $0.safeAreaLayoutGuide }
                make.verticalEdges.equalToSuperview()
                
            case (false, true):
                make.horizontalEdges.equalToSuperview()
                make.verticalEdges.equalToSuperview { $0.safeAreaLayoutGuide }
                
            case (false, false):
                make.edges.equalToSuperview()
            }
        }
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
