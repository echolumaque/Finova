//
//  CashflowView.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/14/25.
//

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
        layer.cornerRadius = 20
        clipsToBounds = true
        backgroundColor = cashflowType.color

        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 15
//        hStack.alignment = .center
        hStack.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding)
        ])
        
        let cashflowImage = UIImageView(image: cashflowType.imageToUse)
        cashflowImage.contentMode = .scaleAspectFit
        cashflowImage.layer.cornerRadius = 10
        cashflowImage.layer.masksToBounds = true
        cashflowImage.layer.backgroundColor = UIColor.white.cgColor
        cashflowImage.tintColor = cashflowType.color
        cashflowImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cashflowImage.widthAnchor.constraint(equalToConstant: 50),
            cashflowImage.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.spacing = -5
        
        let cashflowName = DynamicLabel(
            textColor: .white,
            font: UIFont.preferredFont(for: .callout, weight: .bold),
            minimumScaleFactor: 0.75,
            numberOfLines: 1
        )
        cashflowName.text = cashflowType.rawValue
        
        let value = DynamicLabel(
            textColor: .white,
            font: UIFont.preferredFont(for: .title1, weight: .bold),
            minimumScaleFactor: 0.75,
            numberOfLines: 1
        )
        value.text = "$500.23"
        
        hStack.addArrangedSubviews(cashflowImage, vStack)
        vStack.addArrangedSubviews(cashflowName, value)
    }
}

#Preview {
    CashflowView(cashflowType: .income)
}
