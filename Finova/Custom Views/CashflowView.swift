//
//  CashflowView.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/14/25.
//

//import UIKit
//
//class CashflowView: UIView {
//    private let horizontalPadding: CGFloat = 20
//    private let verticalPadding: CGFloat = 8
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    convenience init(cashflowType: CashflowType) {
//        self.init(frame: .zero)
//        configure(cashflowType: cashflowType)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configure(cashflowType: CashflowType) {
//        let vStack = UIStackView(frame: .zero)
//        vStack.axis = .vertical
//        vStack.backgroundColor = cashflowType.color
//        vStack.spacing = 25
//        vStack.alignment = .leading
//        vStack.distribution = .fill
//        
//        vStack.layer.cornerRadius = 20
//        vStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        vStack.isLayoutMarginsRelativeArrangement = true
//        
//        vStack.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(vStack)
//        NSLayoutConstraint.activate([
//            vStack.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
//            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
//            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
//            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding)
//        ])
//       
//        
//        let cashflowImage = UIImageView(image: cashflowType.imageToUse)
//        cashflowImage.contentMode = .scaleAspectFit
//        cashflowImage.layer.cornerRadius = 10
//        cashflowImage.layer.masksToBounds = true
//        cashflowImage.layer.backgroundColor = UIColor.white.cgColor
//        
//        cashflowImage.tintColor = cashflowType.color
//        cashflowImage.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            cashflowImage.widthAnchor.constraint(equalToConstant: 40),
//            cashflowImage.heightAnchor.constraint(equalToConstant: 40),
//        ])
//        
//        let cashflowNameAndValue = UIView(frame: .zero)
//        
//        let cashflowName = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .title3, weight: .regular))
//        cashflowName.text = cashflowType.rawValue
//        
//        let cashflowValue = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .title1, weight: .bold), minimumScaleFactor: 1, numberOfLines: 1)
//        cashflowValue.text = "$5000"
//        
//        cashflowNameAndValue.addSubviews(cashflowName, cashflowValue)
//        NSLayoutConstraint.activate([
//            cashflowName.topAnchor.constraint(equalTo: cashflowNameAndValue.topAnchor),
//            cashflowValue.topAnchor.constraint(equalTo: cashflowName.bottomAnchor),
//            cashflowValue.bottomAnchor.constraint(equalTo: cashflowNameAndValue.bottomAnchor)
//        ])
//        
//        vStack.addArrangedSubviews(cashflowImage, cashflowNameAndValue)
//    }
//}
//
//#Preview {
//    CashflowView(cashflowType: .income)
//}

import SnapKit
import UIKit

class CashflowView: UIView {
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 8
    
    private let value = DynamicLabel(
        textColor: .white,
        font: UIFont.preferredFont(for: .title1, weight: .bold),
        minimumScaleFactor: 0.5
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(cashflowType: CashflowType) {
        self.init(frame: .zero)
        configure(cashflowType: cashflowType)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(cashflowType: CashflowType) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 30
        clipsToBounds = true
        backgroundColor = cashflowType.color
        
        let hStack = UIStackView()
//        hStack.backgroundColor = .green
        hStack.axis = .horizontal
        hStack.spacing = 16
        hStack.layoutMargins = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 0)
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(verticalPadding)
            make.horizontalEdges.equalToSuperview()
        }
        
        let cashflowImage = UIImageView(image: cashflowType.imageToUse)
        cashflowImage.contentMode = .scaleAspectFit
        cashflowImage.layer.cornerRadius = 15
        cashflowImage.layer.masksToBounds = true
        cashflowImage.layer.backgroundColor = UIColor.white.cgColor
        cashflowImage.tintColor = cashflowType.color
        cashflowImage.translatesAutoresizingMaskIntoConstraints = false
        cashflowImage.snp.makeConstraints { $0.size.equalTo(40) }
        hStack.addArrangedSubview(cashflowImage)
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.spacing = 4
        hStack.addArrangedSubview(vStack)
        
        let cashflowName = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .headline, weight: .semibold))
        cashflowName.text = cashflowType.rawValue
        vStack.addArrangedSubview(cashflowName)
        
        value.text = "\(Locale.current.currencySymbol ?? "$")0.00"
        vStack.addArrangedSubview(value)
    }
    
    func update(newValue: String) {
//        let cleanedValue = newValue < 0 ? -newValue : newValue
//        value.text = "\(Locale.current.currencySymbol ?? "$")\(cleanedValue)"
        DispatchQueue.main.async {
            self.value.text = newValue
        }
    }
}

#Preview {
//    CashflowView(cashflowType: .credit)
    
    let incomeCashflowBadge = CashflowView(cashflowType: .credit)
    let expensesCashflowBadge = CashflowView(cashflowType: .debit)
    let cashflowStackView = UIStackView(frame: .zero)
    cashflowStackView.axis = .horizontal
    cashflowStackView.distribution = .fillEqually
    cashflowStackView.alignment = .center
    cashflowStackView.spacing = 30
    cashflowStackView.translatesAutoresizingMaskIntoConstraints = false
    cashflowStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    cashflowStackView.isLayoutMarginsRelativeArrangement = true

    cashflowStackView.addArrangedSubviews(incomeCashflowBadge, expensesCashflowBadge)
//    incomeCashflowBadge.widthAnchor.constraint(equalTo: expensesCashflowBadge.widthAnchor).isActive = true

    return cashflowStackView
}
