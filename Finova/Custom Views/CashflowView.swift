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
        layer.cornerRadius = 60
        clipsToBounds = true
        backgroundColor = cashflowType.color

        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 30
        hStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalPadding),
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalPadding),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalPadding)
        ])
        
        let cashflowImage = UIImageView(image: cashflowType.imageToUse)
        cashflowImage.contentMode = .scaleAspectFit
        cashflowImage.layer.cornerRadius = 15
        cashflowImage.layer.masksToBounds = true
        cashflowImage.layer.backgroundColor = UIColor.white.cgColor
        cashflowImage.tintColor = cashflowType.color
        cashflowImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cashflowImage.widthAnchor.constraint(equalToConstant: 70),
            cashflowImage.heightAnchor.constraint(equalToConstant: 70),
        ])
        hStack.addArrangedSubview(cashflowImage)
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.spacing = -5
        hStack.addArrangedSubview(vStack)
        
        let cashflowName = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .title2, weight: .semibold))
        cashflowName.text = cashflowType.rawValue
        vStack.addArrangedSubview(cashflowName)
        
        let value = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .extraLargeTitle, weight: .bold))
        value.text = "$5000"
        vStack.addArrangedSubview(value)
    }
}

#Preview {
    CashflowView(cashflowType: .income)
}
