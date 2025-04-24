//
//  TransactionCell.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/16/25.
//

import SnapKit
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
        
        // MARK: For testing only
        transactionTitle.text = "Groceries"
        transactionDesc.text = "Bought groceries"
        transactionCost.text = "- $120"
        transactionTime.text = "10:00 AM"
        
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
        mainHStack.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(verticalPadding)
            make.leading.equalTo(contentView.snp.leading).offset(horizontalPadding)
            make.trailing.equalTo(contentView.snp.trailing).offset(-horizontalPadding)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-verticalPadding)
        }
        
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
        transactionImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalTo(imageContainer.snp.top).offset(10)
            make.leading.equalTo(imageContainer.snp.leading).offset(10)
            make.trailing.equalTo(imageContainer.snp.trailing).offset(-10)
            make.bottom.equalTo(imageContainer.snp.bottom).offset(-10)
        }
        
        mainHStack.addArrangedSubviews(imageContainer)
    }
    
    private func configureFirstVStack() {
        firstVStack.axis = .vertical
        firstVStack.spacing = 8
        firstVStack.alignment = .leading
        firstVStack.translatesAutoresizingMaskIntoConstraints = false
        firstVStack.distribution = .fill
        mainHStack.addArrangedSubview(firstVStack)
        
        firstVStack.addArrangedSubview(transactionTitle)
        firstVStack.addArrangedSubview(transactionDesc)
        secondVStack.addArrangedSubview(transactionCost)
        secondVStack.addArrangedSubview(transactionTime)
    }
    
    private func configureSecondVStack() {
        secondVStack.axis = .vertical
        secondVStack.spacing = 8
        secondVStack.alignment = .trailing
        secondVStack.translatesAutoresizingMaskIntoConstraints = false
        secondVStack.distribution = .fill
        mainHStack.addArrangedSubview(secondVStack)
    }
    
    func set(transaction: Transaction) {
        transactionTitle.text = transaction.type?.name ?? "Unavailable"
        transactionDesc.text = transaction.type?.details ?? "Unavailable"
        transactionCost.text = String(format: "- $%.2f", transaction.value)
        transactionTime.text = transaction.date?.customFormat("hh:mm a")
        
    }
}

#Preview {
//    Task {
//        let coreDataStack = CoreDataStack(inMemory: true)
//        let hey = Account.getPredefinedAccounts(in: await coreDataStack.viewContext)
//    }
//    let cell =
//    return cell
    TransactionCell()
}
