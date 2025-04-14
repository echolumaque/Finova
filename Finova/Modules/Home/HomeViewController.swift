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
        
        accountStackView.layoutMargins = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        accountStackView.isLayoutMarginsRelativeArrangement = true
        
//        accountStackView.clipsToBounds = true
//        accountStackView.layer.cornerRadius = 35
//        accountStackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        accountStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountStackView)
        NSLayoutConstraint.activate([
            accountStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accountStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accountStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 3)
        ])
        
        let accountBtn = UIButton(configuration: .tinted())
        accountBtn.setTitle("Select Account", for: .normal)
        accountBtn.setTitleColor(.white, for: .normal)
        accountBtn.backgroundColor = UIColor.primaryColor
        accountBtn.layer.cornerRadius = 20
        accountBtn.clipsToBounds = true
        accountBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountBtn.widthAnchor.constraint(equalToConstant: 150),
            accountBtn.heightAnchor.constraint(equalToConstant: 40),
        ])
        
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
        
        let accountBalance = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .extraLargeTitle, weight: .bold))
        accountBalance.text = "$5,000.00"
        accountBalanceAndName.addSubview(accountBalance)
        NSLayoutConstraint.activate([
            accountBalance.topAnchor.constraint(equalTo: accountBalanceAndName.topAnchor, constant: verticalPadding),
            accountBalance.centerXAnchor.constraint(equalTo: accountBalanceAndName.centerXAnchor)
        ])
        
        let accountName = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .title2, weight: .semibold))
        accountName.text = "Savings"
        accountBalanceAndName.addSubview(accountName)
        NSLayoutConstraint.activate([
            accountName.topAnchor.constraint(equalTo: accountBalance.bottomAnchor, constant: verticalPadding),
            accountName.centerXAnchor.constraint(equalTo: accountBalanceAndName.centerXAnchor)
        ])
        
        accountStackView.addArrangedSubviews(accountBtn, accountBalanceAndName)
    }
    
    private func configureCashflowBadges() {
        let cashflowStackView = UIStackView(frame: .zero)
        cashflowStackView.backgroundColor = .systemBackground
        cashflowStackView.axis = .horizontal
        cashflowStackView.alignment = .center
        cashflowStackView.distribution = .fillEqually
        cashflowStackView.spacing = 15
        
        cashflowStackView.layoutMargins = UIEdgeInsets(top: 28, left: 20, bottom: 5, right: 28)
        cashflowStackView.isLayoutMarginsRelativeArrangement = true
        
        cashflowStackView.clipsToBounds = true
        cashflowStackView.layer.cornerRadius = 35
        cashflowStackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        cashflowStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cashflowStackView)
        NSLayoutConstraint.activate([
            cashflowStackView.topAnchor.constraint(equalTo: accountStackView.bottomAnchor, constant: -35),
            cashflowStackView.leadingAnchor.constraint(equalTo: accountStackView.leadingAnchor),
            cashflowStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let incomeCashflow = CashflowView(cashflowType: .income)
        let expensesCashflow = CashflowView(cashflowType: .expense)
        
        cashflowStackView.addArrangedSubviews(incomeCashflow, expensesCashflow)
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
