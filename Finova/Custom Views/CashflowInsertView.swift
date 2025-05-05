//
//  CashflowInsertView.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import SnapKit
import UIKit

protocol CashflowInsertViewDelegate: AnyObject {
    func onTapped(cashflowType: CashflowType)
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTapped() {
        let actionSheet = UIAlertController(
            title: "Add Cashflow",
            message: "Please select an action whether you are adding an income or an expense.",
            preferredStyle: .actionSheet
        )
        
        for cashflow in CashflowType.allCases {
            actionSheet.addAction(UIAlertAction(
                title: "Add \(cashflow.rawValue)",
                style: cashflow == .credit ? .default : .destructive,
                handler: onActionTapped
            ))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        UIApplication.topViewController()?.present(actionSheet, animated: true)
    }
    
    private func onActionTapped(_ action: UIAlertAction) {
        let cashflowType: CashflowType = switch action.title {
        case "Add Credit": .credit
        case "Add Debit": .debit
        default: .credit
        }
        
        delegate?.onTapped(cashflowType: cashflowType)
    }
}

#Preview {
    CashflowInsertView(frame: .zero)
}
