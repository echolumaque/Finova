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


import UIKit

class CashflowView: UIView {
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 8

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
        hStack.axis = .horizontal
//        hStack.backgroundColor = .red
        hStack.spacing = 15
        hStack.layoutMargins = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding)
        ])
        
        let cashflowImage = UIImageView(image: cashflowType.imageToUse)
        cashflowImage.contentMode = .scaleAspectFit
        cashflowImage.layer.cornerRadius = 15
        cashflowImage.layer.masksToBounds = true
        cashflowImage.layer.backgroundColor = UIColor.white.cgColor
        cashflowImage.tintColor = cashflowType.color
        cashflowImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cashflowImage.widthAnchor.constraint(equalToConstant: 40),
            cashflowImage.heightAnchor.constraint(equalToConstant: 40),
        ])
        hStack.addArrangedSubview(cashflowImage)
        
        let vStack = UIStackView()
//        vStack.backgroundColor = .blue
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.spacing = 4
        hStack.addArrangedSubview(vStack)
        
        let cashflowName = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .headline, weight: .semibold))
        cashflowName.text = cashflowType.rawValue
        vStack.addArrangedSubview(cashflowName)
        
        let value = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .title1, weight: .bold), minimumScaleFactor: 0.65)
        value.text = "$5,000.46"
        vStack.addArrangedSubview(value)
    }
}

#Preview {
    CashflowView(cashflowType: .credit)
}
