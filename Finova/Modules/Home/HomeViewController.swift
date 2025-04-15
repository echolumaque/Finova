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
    let container: Resolver
    var presenter: HomePresenter?
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 8
    
    private let accountStackView = UIStackView(frame: .zero)
    
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
        
        configureAccount()
        configureCashflowBadges()
        
        Task { [weak self] in
            guard let self else { return }
            await presenter?.getPredefinedAccounts()
        }
    }
    
    private func configureAccount() {
        accountStackView.backgroundColor = UIColor.primaryColor
        accountStackView.axis = .vertical
        accountStackView.alignment = .center
        accountStackView.spacing = 20
        
        accountStackView.layoutMargins = UIEdgeInsets(top: 35, left: 20, bottom: 35, right: 20)
        accountStackView.isLayoutMarginsRelativeArrangement = true
        
        accountStackView.clipsToBounds = true
        accountStackView.layer.cornerRadius = 30
//        accountStackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        accountStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountStackView)
        NSLayoutConstraint.activate([
            accountStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            accountStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            accountStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding)
        ])
        
        let accountBtn = UIButton(configuration: .tinted())
        accountBtn.setTitle("Select Account", for: .normal)
        accountBtn.setTitleColor(.white, for: .normal)
        accountBtn.backgroundColor = UIColor.primaryColor
        accountBtn.layer.cornerRadius = 20
        accountBtn.clipsToBounds = true
        
        let option1 = UIAction(title: "Account 1") { _ in
            print("Option 1 selected")
        }
        let option2 = UIAction(title: "Account 2") { _ in
            print("Option 2 selected")
        }
        
        let menu = UIMenu(options: .singleSelection, children: [option1, option2])
        accountBtn.menu = menu
        accountBtn.showsMenuAsPrimaryAction = true
        
        let accountBalanceAndName = UIView(frame: .zero)
        
        let accountName = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .title3, weight: .semibold))
        accountName.text = "Available Balance"
        accountBalanceAndName.addSubview(accountName)
        NSLayoutConstraint.activate([
            accountName.topAnchor.constraint(equalTo: accountBalanceAndName.topAnchor),
            accountName.centerXAnchor.constraint(equalTo: accountBalanceAndName.centerXAnchor)
        ])
        
        let accountBalance = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .extraLargeTitle, weight: .bold))
        accountBalance.text = "$5,000.00"
        accountBalanceAndName.addSubview(accountBalance)
        NSLayoutConstraint.activate([
            accountBalance.topAnchor.constraint(equalTo: accountName.bottomAnchor, constant: verticalPadding),
            accountBalance.centerXAnchor.constraint(equalTo: accountBalanceAndName.centerXAnchor),
            accountBalance.bottomAnchor.constraint(equalTo: accountBalanceAndName.bottomAnchor)
        ])
        
        accountStackView.addArrangedSubviews(accountBtn, accountBalanceAndName)
    }
    
    private func configureCashflowBadges() {
        let cashflowStackView = UIStackView(frame: .zero)
        cashflowStackView.backgroundColor = .systemBackground
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
        view.addSubview(cashflowStackView)
        NSLayoutConstraint.activate([
            cashflowStackView.topAnchor.constraint(equalTo: accountStackView.bottomAnchor, constant: verticalPadding),
            cashflowStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            cashflowStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding)
        ])
        
        let incomeCashflow = CashflowView(cashflowType: .income)
        let expensesCashflow = CashflowView(cashflowType: .expense)
        
        cashflowStackView.addArrangedSubviews(incomeCashflow, expensesCashflow)
        
        let transactionCell = TransactionCell()
        transactionCell.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(transactionCell)
        NSLayoutConstraint.activate([
            transactionCell.topAnchor.constraint(equalTo: cashflowStackView.bottomAnchor, constant: verticalPadding),
            transactionCell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionCell.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            transactionCell.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
