//
//  HomeViewController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import UIKit
import Swinject

protocol HomeView: AnyObject {
    var presenter: HomePresenter? { get set }
    func updateAccounts(_ accounts: [Account])
}

class HomeViewController: UIViewController, HomeView {
    private let container: Resolver
    var presenter: HomePresenter?
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 8
    
    private lazy var containerView = UIView(frame: .zero)
    private lazy var accountMenuStackView = UIStackView(frame: .zero)
    private lazy var accountStackView = UIStackView(frame: .zero)
    private lazy var recentTxnLabel = DynamicLabel(textColor: .black, font: UIFont.preferredFont(for: .title2, weight: .semibold))
    
    init(container: Resolver) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureAccountContainerView()
        configureTopSection()
        configureMenuStackView()
        configureCashflowBadges()
        configureRecentTxnLabel()
        
        Task { [weak self] in
            guard let self else { return }
            await presenter?.getPredefinedAccounts()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [UIColor(rgb: 0xFFF6E5).cgColor, UIColor(rgb: 0xF8EDD8).withAlphaComponent(0.15).cgColor]
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configureAccountContainerView() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 30
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureTopSection() {
        accountStackView.axis = .vertical
        accountStackView.alignment = .center
        accountStackView.spacing = 20
        
//        accountStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 35, right: 0)
//        accountStackView.isLayoutMarginsRelativeArrangement = true
        
//        accountStackView.clipsToBounds = true
//        accountStackView.layer.cornerRadius = 30
//        accountStackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        accountStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(accountStackView)
        NSLayoutConstraint.activate([
            accountStackView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            accountStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding),
            accountStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalPadding),
            accountStackView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
        
        let accountBalanceAndName = UIView(frame: .zero)
        let availableBalance = DynamicLabel(textColor: .secondaryLabel, font: UIFont.preferredFont(for: .title3, weight: .semibold))
        availableBalance.text = "Available Balance"
        accountBalanceAndName.addSubview(availableBalance)
        NSLayoutConstraint.activate([
            availableBalance.topAnchor.constraint(equalTo: accountBalanceAndName.topAnchor),
            availableBalance.centerXAnchor.constraint(equalTo: accountBalanceAndName.centerXAnchor)
        ])
        
        let accountBalance = DynamicLabel(textColor: .label, font: UIFont.preferredFont(for: .extraLargeTitle, weight: .bold))
        accountBalance.text = "$5,000.00"
        accountBalanceAndName.addSubview(accountBalance)
        NSLayoutConstraint.activate([
            accountBalance.topAnchor.constraint(equalTo: availableBalance.bottomAnchor, constant: verticalPadding),
            accountBalance.centerXAnchor.constraint(equalTo: accountBalanceAndName.centerXAnchor),
            accountBalance.bottomAnchor.constraint(equalTo: accountBalanceAndName.bottomAnchor)
        ])
        
        accountStackView.addArrangedSubviews(accountMenuStackView, accountBalanceAndName)
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
    
    private func configureCashflowBadges() {
        let cashflowStackView = UIStackView(frame: .zero)
        cashflowStackView.axis = .horizontal
        cashflowStackView.alignment = .center
        cashflowStackView.distribution = .fillEqually
        cashflowStackView.spacing = horizontalPadding
        
//        cashflowStackView.layoutMargins = UIEdgeInsets(top: 28, left: 20, bottom: 5, right: 28)
//        cashflowStackView.isLayoutMarginsRelativeArrangement = true
        
//        cashflowStackView.clipsToBounds = true
//        cashflowStackView.layer.cornerRadius = 35
//        cashflowStackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        cashflowStackView.translatesAutoresizingMaskIntoConstraints = false
        accountStackView.addArrangedSubview(cashflowStackView)
        NSLayoutConstraint.activate([
            cashflowStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            cashflowStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding)
        ])
        
        let incomeCashflow = CashflowView(cashflowType: .income)
        let expensesCashflow = CashflowView(cashflowType: .expense)
        
        cashflowStackView.addArrangedSubviews(incomeCashflow, expensesCashflow)
        
//        let transactionCell = TransactionCell()
//        transactionCell.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(transactionCell)
//        NSLayoutConstraint.activate([
//            transactionCell.topAnchor.constraint(equalTo: cashflowStackView.bottomAnchor, constant: verticalPadding),
//            transactionCell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            transactionCell.trailingAnchor.constraint(equalTo: view.trailingAnchor),
////            transactionCell.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
        
    }
    
    private func configureRecentTxnLabel() {
        recentTxnLabel.text = "Recent Transaction(s)"
        view.addSubview(recentTxnLabel)
        NSLayoutConstraint.activate([
            recentTxnLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: verticalPadding),
            recentTxnLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding),
            recentTxnLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
    func updateAccounts(_ accounts: [Account]) {
        
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

#Preview {
    HomeViewController(container: Container())
}
