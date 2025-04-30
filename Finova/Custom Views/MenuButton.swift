//
//  MenuButton.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/30/25.
//

import UIKit

class MenuButton: UIButton {
    weak var anchorView: UIView?
    var offset = CGPoint.zero
    
    override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
        let originalAttachment = super.menuAttachmentPoint(for: configuration)
        guard let anchorView, let container = anchorView.superview else {
            return CGPoint(x: originalAttachment.x + offset.x, y: originalAttachment.y + offset.y)
        }
        
        let anchorFrame = convert(anchorView.frame, from: container)
        let anchorX: CGFloat = switch contentHorizontalAlignment {
        case .left, .leading: anchorFrame.minX
        case .center, .fill: anchorFrame.midX
        case .right, .trailing: anchorFrame.maxX
        @unknown default: anchorFrame.midX
        }
        
        return CGPoint(x: anchorX + offset.x, y: originalAttachment.y + offset.y)
    }
}
