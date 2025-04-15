//
//  TransactionCell.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/16/25.
//

import UIKit

class TransactionCell: UICollectionViewCell {
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 8
    
    private lazy var mainHStack = UIStackView(frame: .zero)
    private lazy var firstVStack = UIStackView(frame: .zero)
    private lazy var secondVStack = UIStackView(frame: .zero)
    private lazy var transactionImage = UIImageView(frame: .zero)
    private lazy var transactionTitle = DynamicLabel(
        textColor: .label,
        font: UIFont.preferredFont(for: .title3, weight: .regular),
        numberOfLines: 1
    )
    private lazy var transactionDesc = DynamicLabel(
        textColor: .secondaryLabel,
        font: UIFont.preferredFont(for: .body, weight: .regular),
        numberOfLines: 1
    )
    private lazy var transactionCost = DynamicLabel(
        textColor: .systemRed,
        font: UIFont.preferredFont(for: .title3, weight: .bold),
        numberOfLines: 1
    )
    private lazy var transactionTime = DynamicLabel(
        textColor: .secondaryLabel,
        font: UIFont.preferredFont(for: .body, weight: .regular),
        numberOfLines: 1
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureMainHStack()
        configureFirstVStack()
        configureSecondVStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureMainHStack() {
        mainHStack.axis = .horizontal
        mainHStack.spacing = 10
        mainHStack.alignment = .center
        mainHStack.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.5)
        mainHStack.layer.cornerRadius = 24
        mainHStack.layoutMargins = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        mainHStack.isLayoutMarginsRelativeArrangement = true
        
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainHStack)
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            mainHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
//            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
            mainHStack.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        configureImage()
    }
    
    private func configureImage() {
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.backgroundColor = UIColor(rgb: 0xFF7043).withAlphaComponent(0.2)
        imageContainer.layer.cornerRadius = 10
        
        transactionImage.translatesAutoresizingMaskIntoConstraints = false
        transactionImage.contentMode = .scaleAspectFit
        transactionImage.layer.cornerRadius = 16
        transactionImage.image = UIImage(systemName: "cart.fill")
        transactionImage.tintColor = UIColor(rgb: 0xFF7043)
        
        imageContainer.addSubview(transactionImage)
        NSLayoutConstraint.activate([
            transactionImage.widthAnchor.constraint(equalToConstant: 40),
            transactionImage.heightAnchor.constraint(equalToConstant: 40),
            transactionImage.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 10),
            transactionImage.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 10),
            transactionImage.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -10),
            transactionImage.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -10),
        ])
        
        mainHStack.addArrangedSubviews(imageContainer)
    }
    
    private func configureFirstVStack() {
        firstVStack.axis = .vertical
        firstVStack.spacing = 8
        firstVStack.alignment = .leading
        firstVStack.translatesAutoresizingMaskIntoConstraints = false
        firstVStack.distribution = .fill
        mainHStack.addArrangedSubview(firstVStack)
        
        configureTransactionTitle()
        configureTransactionDesc()
    }
    
    private func configureTransactionTitle() {
        transactionTitle.text = "Groceries"
        firstVStack.addArrangedSubview(transactionTitle)
    }
    
    private func configureTransactionDesc() {
        transactionDesc.text = "Bought groceries"
        firstVStack.addArrangedSubview(transactionDesc)
    }
    
    private func configureSecondVStack() {
        secondVStack.axis = .vertical
        secondVStack.spacing = 8
        secondVStack.alignment = .trailing
        secondVStack.translatesAutoresizingMaskIntoConstraints = false
        secondVStack.distribution = .fill
        mainHStack.addArrangedSubview(secondVStack)
        
        configureTransactionCost()
        configureTransactionTime()
    }
    
    private func configureTransactionCost() {
        transactionCost.text = "- $120"
        secondVStack.addArrangedSubview(transactionCost)
    }
    
    private func configureTransactionTime() {
        transactionTime.text = "10:00 AM"
        secondVStack.addArrangedSubview(transactionTime)
    }
    
    func set() {
        
    }
}

#Preview {
//    Task {
//        let coreDataStack = CoreDataStack(inMemory: true)
//        let hey = Account.getPredefinedAccounts(in: await coreDataStack.viewContext)
//    }
    return TransactionCell()
}
