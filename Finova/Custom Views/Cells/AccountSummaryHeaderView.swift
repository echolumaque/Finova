//
//  AccountSummaryHeaderView.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/24/25.
//

import SnapKit
import UIKit

//class AccountSummaryHeaderView: UICollectionReusableView {
class AccountSummaryHeaderView: UIView {
    static let reuseId = "ReuseId"
    
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 8
    
    private let helperStackView = UIStackView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let accountMenuStackView = UIStackView(frame: .zero)
    private let accountStackView = UIStackView(frame: .zero)
    private let recentTxnLabel = DynamicLabel(textColor: .black, font: UIFont.preferredFont(for: .title2, weight: .semibold))
    private let frequencySegmentedControl = UISegmentedControl(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        configureHelperStackView()
        configureAccountContainerView()
        configureAccountStackView()
        configureMenuStackView()
        configureAccountBalanceAndName()
        configureCashflowBadges()
        configureRecentTxnLabel()
        configureFrequencySegmentedControl()
    }
    
    private func configureHelperStackView() {
        helperStackView.axis = .vertical
        helperStackView.alignment = .fill
        helperStackView.translatesAutoresizingMaskIntoConstraints = false
        helperStackView.layoutMargins = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        helperStackView.isLayoutMarginsRelativeArrangement = true
        
        addSubview(helperStackView)
        helperStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureAccountContainerView() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 30
//        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        helperStackView.addArrangedSubview(containerView)
    }
    
    private func configureAccountStackView() {
        accountStackView.axis = .vertical
        accountStackView.alignment = .center
        accountStackView.spacing = 20
        
        accountStackView.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        accountStackView.isLayoutMarginsRelativeArrangement = true
        
        accountStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(accountStackView)
        accountStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(containerView.snp.leading).offset(horizontalPadding)
            make.trailing.equalTo(containerView.snp.trailing).offset(-horizontalPadding)
            make.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
    
    private func configureMenuStackView() {
        accountMenuStackView.axis = .horizontal
        accountMenuStackView.spacing = 4
        
        let selectedAccountName = DynamicLabel(textColor: .secondaryLabel, font: UIFont.preferredFont(for: .subheadline, weight: .semibold))
        selectedAccountName.text = "Savings"
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.down")?.withConfiguration(UIImage.SymbolConfiguration(scale: .small)))
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.contentMode = .scaleAspectFit
//        chevron.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        chevron.tintColor = UIColor.primaryColor
        
        accountMenuStackView.addArrangedSubviews(selectedAccountName, chevron)
        
        // MARK: Configure the menu when accountMenuStackView is tapped
        let accountBtn = UIButton(frame: .zero)
        accountBtn.translatesAutoresizingMaskIntoConstraints = false
        accountMenuStackView.addSubview(accountBtn)
        accountBtn.pinToEdges(of: accountMenuStackView)
        
        let option1 = UIAction(title: "Account 1") { _ in
            print("Option 1 selected")
        }
        let option2 = UIAction(title: "Account 2") { _ in
            print("Option 2 selected")
        }
        
        let menu = UIMenu(options: .singleSelection, children: [option1, option2])
        accountBtn.menu = menu
        accountBtn.showsMenuAsPrimaryAction = true
        
        accountMenuStackView.bringSubviewToFront(accountBtn)
    }

    private func configureAccountBalanceAndName() {
        let accountBalanceAndName = UIView(frame: .zero)
        let availableBalance = DynamicLabel(textColor: .secondaryLabel, font: UIFont.preferredFont(for: .title3, weight: .semibold))
        availableBalance.text = "Available Balance"
        accountBalanceAndName.addSubview(availableBalance)
        availableBalance.snp.makeConstraints { make in
            make.top.equalTo(accountBalanceAndName.snp.top)
            make.centerX.equalTo(accountBalanceAndName.snp.centerX)
        }
        
        let accountBalance = DynamicLabel(textColor: .label, font: UIFont.preferredFont(for: .extraLargeTitle, weight: .bold))
        accountBalance.text = "$5,000.00"
        accountBalanceAndName.addSubview(accountBalance)
        accountBalance.snp.makeConstraints { make in
            make.top.equalTo(availableBalance.snp.bottom).offset(verticalPadding)
            make.centerX.equalTo(accountBalanceAndName.snp.centerX)
            make.bottom.equalTo(accountBalanceAndName.snp.bottom)
        }
        
        accountStackView.addArrangedSubviews(accountMenuStackView, accountBalanceAndName)
    }
    
    private func configureCashflowBadges() {
        let cashflowStackView = UIStackView(frame: .zero)
        cashflowStackView.axis = .horizontal
        cashflowStackView.alignment = .center
        cashflowStackView.distribution = .fillEqually
        cashflowStackView.spacing = horizontalPadding
        cashflowStackView.translatesAutoresizingMaskIntoConstraints = false
        cashflowStackView.layoutMargins = UIEdgeInsets(top: 0, left: -horizontalPadding, bottom: 0, right: -horizontalPadding)
        cashflowStackView.isLayoutMarginsRelativeArrangement = true
        accountStackView.addArrangedSubview(cashflowStackView)
        
        let incomeCashflow = CashflowView(cashflowType: .credit)
        let expensesCashflow = CashflowView(cashflowType: .debit)
        cashflowStackView.addArrangedSubviews(incomeCashflow, expensesCashflow)
    }
    
    private func configureRecentTxnLabel() {
        recentTxnLabel.text = "Recent Transaction(s)"
        helperStackView.addArrangedSubview(recentTxnLabel)
    }
    
    private func configureFrequencySegmentedControl() {
        _ = Frequency.allCases.enumerated().map { index, frequency in
            frequencySegmentedControl.insertSegment(withTitle: frequency.rawValue, at: index, animated: true)
        }
        
        frequencySegmentedControl.selectedSegmentTintColor = UIColor.secondaryColor
        frequencySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        frequencySegmentedControl.addTarget(self, action: #selector(frequencyDidChange(_:)), for: .valueChanged)
        frequencySegmentedControl.selectedSegmentIndex = 0

        helperStackView.setCustomSpacing(25, after: recentTxnLabel)
        helperStackView.addArrangedSubview(frequencySegmentedControl)
        
        let emptyView = UIView(frame: .zero)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.snp.makeConstraints { make in make.height.equalTo(25) }
        
        helperStackView.addArrangedSubview(emptyView)
    }
    
    @objc func frequencyDidChange(_ segmentedControl: UISegmentedControl) {
//        segmentedControl.selectedSegmentIndex
    }
}

#Preview {
    AccountSummaryHeaderView()
}
