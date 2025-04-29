//
//  CashflowViewController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import SnapKit
import UIKit

protocol CashflowViewProtocol: AnyObject {
    var presenter: CashflowPresenter? { get set }
}

class CashflowViewController: UIViewController, CashflowViewProtocol {
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 8
    private let cashflowType: CashflowType
    
    var presenter: CashflowPresenter?
    
    private let mainVStack = UIStackView(frame: .zero)
    private let bottomVStack = UIStackView(frame: .zero)
    init(cashflowType: CashflowType) {
        self.cashflowType = cashflowType
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = cashflowType.color
        navigationItem.title = cashflowType.singularName
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        configureMainVStack()
        configureTopSection()
        configureBottomSection()
        configureAccountToUse()
        configureCategory()
        configureDescription()
    }
    
    private func configureMainVStack() {
        mainVStack.axis = .vertical
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainVStack)
        mainVStack.pinToEdges(of: view)
    }
    
    private func configureTopSection() {
        let topContainer = UIView(frame: .zero)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        mainVStack.addArrangedSubview(topContainer)
        topContainer.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        let howMuchLabel = DynamicLabel(textColor: .white.withAlphaComponent(0.4), font: UIFont.preferredFont(for: .title3, weight: .semibold))
        howMuchLabel.text = "How much?"
        topContainer.addSubview(howMuchLabel)
        howMuchLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(horizontalPadding)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview().offset(35)
        }
        
        let valueHStack = UIStackView(frame: .zero)
        valueHStack.axis = .horizontal
        valueHStack.spacing = 1.5
        valueHStack.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(valueHStack)
        valueHStack.snp.makeConstraints { make in
            make.top.equalTo(howMuchLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        let currencyLabel = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .extraLargeTitle, weight: .bold))
        currencyLabel.text = "$"
        
        let valueTextField = UITextField(frame: .zero)
        valueTextField.keyboardType = .decimalPad
        
        valueTextField.font = UIFont.preferredFont(for: .extraLargeTitle, weight: .bold)
        valueTextField.textColor = .white
        valueTextField.adjustsFontSizeToFitWidth = true
        valueTextField.adjustsFontForContentSizeCategory = true
        valueTextField.inputAccessoryView = textFieldToolbar {
            print("text: \(valueTextField.text)")
        }
        
        valueTextField.placeholder = "0"
        valueTextField.delegate = self
        
        valueHStack.addArrangedSubviews(currencyLabel, valueTextField)
    }
    
    private func configureBottomSection() {
        bottomVStack.axis = .vertical
        bottomVStack.spacing = 40
        bottomVStack.backgroundColor = .white
        bottomVStack.clipsToBounds = true
        bottomVStack.layer.cornerRadius = 30
        bottomVStack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomVStack.layoutMargins = UIEdgeInsets(top: 40, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        bottomVStack.isLayoutMarginsRelativeArrangement = true
        
        mainVStack.addArrangedSubview(bottomVStack)
        bottomVStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func configureAccountToUse() {
        let accountStackView = UIStackView(frame: .zero)
        accountStackView.axis = .horizontal
        accountStackView.layer.cornerRadius = 16
        accountStackView.layer.borderWidth = 0.5
        accountStackView.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        bottomVStack.addArrangedSubview(accountStackView)
        accountStackView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.085)
        }
    }
    
    private func configureCategory() {
        let categoryStackView = UIStackView(frame: .zero)
        categoryStackView.axis = .horizontal
        categoryStackView.layer.cornerRadius = 16
        categoryStackView.layer.borderWidth = 0.5
        categoryStackView.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        bottomVStack.addArrangedSubviews(categoryStackView)
        categoryStackView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.085)
        }
    }
    
    private func configureDescription() {
        let descriptionTextView = UITextView(frame: .zero)
        descriptionTextView.delegate = self
        
        descriptionTextView.layer.cornerRadius = 16
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12, left: horizontalPadding, bottom: 12, right: horizontalPadding)
        
        descriptionTextView.font = UIFont.preferredFont(for: .body, weight: .regular)
        descriptionTextView.textColor = .label
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = .secondaryLabel
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        bottomVStack.addArrangedSubviews(descriptionTextView, SpacerView())
        descriptionTextView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
    }
}

extension CashflowViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospective = (currentText as NSString).replacingCharacters(in: range, with: string)
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let separator = NSRegularExpression.escapedPattern(for: decimalSeparator)
        let pattern = "^\\d*(?:\(separator)\\d{0,2})?$"
        
        return prospective.range(of: pattern, options: .regularExpression) != nil
    }
}

extension CashflowViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = .secondaryLabel
        }
    }
}

#Preview {
    CashflowViewController(cashflowType: .income)
}
