//
//  AccountCell.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import UIKit

class AccountCell: UICollectionViewCell {
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 8
    override var isSelected: Bool {
        didSet { cardView.backgroundColor = isSelected ? UIColor.primaryColor : UIColor.secondaryColor }
    }
    
    private let cardView = UIView()
    private let accountNameLabel = DynamicLabel(
        textColor: .white,
        font: UIFont.preferredFont(for: .title3, weight: .semibold),
        numberOfLines: 1
    )
    let accountBalanceLabel = DynamicLabel(
        textColor: .white,
        font: UIFont.preferredFont(for: .footnote, weight: .regular)
    )
    private let accountValueLabel = DynamicLabel(
        textColor: .white,
        font: UIFont.preferredFont(for: .title2, weight: .bold),
        numberOfLines: 1
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func set(account: Account) {
        accountNameLabel.text = account.name ?? ""
        accountValueLabel.text = "$\(account.value)"
    }
    
    private func configure() {
        cardView.backgroundColor = UIColor.secondaryColor
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 10.0
        cardView.clipsToBounds = true
        
        contentView.addSubview(cardView)
        NSLayoutConstraint.activate([
//            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cardView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 180),
            cardView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        accountNameLabel.text = "Visa"
        cardView.addSubview(accountNameLabel)
        NSLayoutConstraint.activate([
            accountNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: verticalPadding),
            accountNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: horizontalPadding),
            accountNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -horizontalPadding),
        ])
        
        accountBalanceLabel.text = "Current Balance"
        cardView.addSubview(accountBalanceLabel)
        NSLayoutConstraint.activate([
            accountBalanceLabel.topAnchor.constraint(equalTo: accountNameLabel.bottomAnchor, constant: 4),
            accountBalanceLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: horizontalPadding),
            accountBalanceLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -horizontalPadding)
        ])
        
        accountValueLabel.text = "$40,000.23"
        cardView.addSubview(accountValueLabel)
        NSLayoutConstraint.activate([
            accountValueLabel.topAnchor.constraint(equalTo: accountBalanceLabel.bottomAnchor, constant: verticalPadding),
            accountValueLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: horizontalPadding),
            accountValueLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -horizontalPadding),
            accountValueLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -verticalPadding)
        ])
    }
}

#Preview {
    AccountCell()
}
