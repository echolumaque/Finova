//
//  TransactionCell.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/16/25.
//

import SnapKit
import UIKit

class TransactionCell: UICollectionViewCell {
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 8
    
    private let mainHStack = UIStackView(frame: .zero)
    private let firstVStack = UIStackView(frame: .zero)
    private let secondVStack = UIStackView(frame: .zero)
    private let imageContainer = UIView(frame: .zero)
    private let transactionImage = UIImageView(frame: .zero)
    private let transactionTitle = DynamicLabel(
        textColor: .label,
        font: UIFont.preferredFont(for: .body, weight: .regular),
        numberOfLines: 1
    )
    private let transactionDesc = DynamicLabel(
        textColor: .secondaryLabel,
        font: UIFont.preferredFont(for: .subheadline, weight: .regular),
        numberOfLines: 1
    )
    private let transactionCost = DynamicLabel(
        textColor: .label,
        font: UIFont.preferredFont(for: .body, weight: .bold),
        minimumScaleFactor: 0.8,
        numberOfLines: 1
    )
    private let transactionTime = DynamicLabel(
        textColor: .secondaryLabel,
        font: UIFont.preferredFont(for: .subheadline, weight: .regular),
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
        mainHStack.layer.cornerRadius = 16
        mainHStack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        mainHStack.isLayoutMarginsRelativeArrangement = true
        
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainHStack)
        mainHStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview { $0.safeAreaLayoutGuide }.inset(horizontalPadding)
            make.verticalEdges.equalToSuperview { $0.safeAreaLayoutGuide }.inset(verticalPadding)
        }
        
        configureImage()
    }
    
    private func configureImage() {
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.layer.cornerRadius = 10
        
        transactionImage.translatesAutoresizingMaskIntoConstraints = false
        transactionImage.contentMode = .scaleAspectFit
        transactionImage.layer.cornerRadius = 12
        
        imageContainer.addSubview(transactionImage)
        transactionImage.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(imageContainer.snp.top).offset(10)
            make.leading.equalTo(imageContainer.snp.leading).offset(10)
            make.trailing.equalTo(imageContainer.snp.trailing).offset(-10)
            make.bottom.equalTo(imageContainer.snp.bottom).offset(-10)
        }
        
        mainHStack.addArrangedSubviews(imageContainer)
    }
    
    private func configureFirstVStack() {
        firstVStack.axis = .vertical
        firstVStack.spacing = 6
        firstVStack.alignment = .leading
        firstVStack.translatesAutoresizingMaskIntoConstraints = false
        firstVStack.distribution = .fill
        mainHStack.addArrangedSubview(firstVStack)
        firstVStack.addArrangedSubviews(transactionTitle, transactionDesc)
    }
    
    private func configureSecondVStack() {
        secondVStack.axis = .vertical
        secondVStack.spacing = 6
        secondVStack.alignment = .trailing
        secondVStack.translatesAutoresizingMaskIntoConstraints = false
        secondVStack.distribution = .fill
        mainHStack.addArrangedSubview(secondVStack)
        secondVStack.addArrangedSubviews(transactionCost, transactionTime)
        secondVStack.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(0.2) }
    }
    
    func set(txnVm: TransactionCellViewModel) {
        let cashflowType = txnVm.cashflowType?.decode(CashflowType.self) ?? .credit
        
        imageContainer.backgroundColor = cashflowType.color.withAlphaComponent(0.2)
        transactionImage.image = UIImage(systemName: txnVm.category?.logo ?? "")
        transactionImage.tintColor = cashflowType.color
        
        transactionTitle.text = txnVm.category?.name ?? "Unavailable"
        
        transactionDesc.text = txnVm.desc ?? "Unavailable"
        
        transactionCost.textColor = cashflowType.color
        transactionCost.text = "\(cashflowType.operatorToUse)\(txnVm.formattedValue ?? "0")"
        
        transactionTime.text = txnVm.date?.customFormat("hh:mm a")
        
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
