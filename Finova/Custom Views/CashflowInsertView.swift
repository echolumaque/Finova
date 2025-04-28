//
//  CashflowInsertView.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import SnapKit
import UIKit

protocol CashflowInsertViewDelegate: AnyObject {
    func onTapped()
}

class CashflowInsertView: UIView {
    weak var delegate: CashflowInsertViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .primaryColor
        clipsToBounds = true
        
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        let imageView = UIImageView(image: UIImage(systemName: "plus", withConfiguration: config))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(test))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func test() {
//        let actionSheet = UIAlertController(
//            title: "Add Cashflow",
//            message: "Please select an action whether you are adding an income or an expense.",
//            preferredStyle: .actionSheet
//        )
//        actionSheet.addAction(UIAlertAction(title: "Add Income", style: .default))
//        actionSheet.addAction(UIAlertAction(title: "Add Expense", style: .destructive))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        UIApplication.topViewController()?.present(actionSheet, animated: true)
        delegate?.onTapped()
    }
}

#Preview {
    CashflowInsertView(frame: .zero)
}
