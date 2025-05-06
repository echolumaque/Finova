//
//  AddAttachmentView.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 5/7/25.
//

import SnapKit
import UIKit

class AddAttachmentView: DashedBorderView {
    private var menu = UIMenu()
    
    convenience init(menu: UIMenu) {
        self.init(color: .separator)
        self.menu = menu
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 8
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .customPaperclipBadgePlus)
        config.baseForegroundColor = .separator
        
        let attachmentBtn = UIButton(configuration: config)
        attachmentBtn.showsMenuAsPrimaryAction = true
        attachmentBtn.menu = menu
        attachmentBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(attachmentBtn)
        attachmentBtn.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

#Preview {
    AddAttachmentView(color: .separator)
}
