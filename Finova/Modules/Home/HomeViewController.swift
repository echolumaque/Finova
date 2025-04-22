//
//  HomeViewController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import UIKit
import SnapKit
import Swinject

protocol HomeView: AnyObject {
    var presenter: HomePresenter? { get set }
    func updateAccounts(_ accounts: [Account])
    func updateTransactions(_ transactions: [Transaction])
}

class HomeViewController: UIViewController, HomeView {
    private let container: Resolver
    var presenter: HomePresenter?
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 8
    
    private lazy var mainScrollView = UIScrollView(frame: .zero)
    private lazy var containerView = UIView(frame: .zero)
    private lazy var accountMenuStackView = UIStackView(frame: .zero)
    private lazy var accountStackView = UIStackView(frame: .zero)
    private lazy var recentTxnLabel = DynamicLabel(textColor: .black, font: UIFont.preferredFont(for: .title2, weight: .semibold))
    
    private lazy var txnCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayoutHelper.createVerticalCompositionalLayout(
            itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)),
            groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)),
            interGroupSpacing: 8
        )
    )
    private var txnDataSource: UICollectionViewDiffableDataSource<Section, Transaction>!
    
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
        
        configureScrollView()
        configureAccountContainerView()
        configureTopSection()
        configureMenuStackView()
        configureCashflowBadges()
        configureRecentTxnLabel()
        configureTxnCollectionView()
        
        Task { [weak self] in
            guard let self else { return }
//            await presenter?.getPredefinedAccounts()
            await presenter?.getPrdefinedTransactions()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [UIColor(rgb: 0xFFF6E5).cgColor, UIColor(rgb: 0xF8EDD8).withAlphaComponent(0.15).cgColor]
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configureScrollView() {
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureAccountContainerView() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 30
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(mainScrollView.snp.leading)
            make.trailing.equalTo(mainScrollView.snp.trailing)
        }
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
        accountStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(containerView.snp.leading).offset(horizontalPadding)
            make.trailing.equalTo(containerView.snp.trailing).offset(-horizontalPadding)
            make.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
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
    }
    
    private func configureRecentTxnLabel() {
        recentTxnLabel.text = "Recent Transaction(s)"
        mainScrollView.addSubview(recentTxnLabel)
        recentTxnLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(containerView.snp.leading).offset(horizontalPadding)
            make.trailing.equalTo(containerView.snp.trailing).offset(-horizontalPadding)
        }
    }
    
    func configureTxnCollectionView() {
        txnCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        txnCollectionView.isScrollEnabled = false
        mainScrollView.addSubview(txnCollectionView)
        txnCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentTxnLabel.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(view.snp.leading).offset(horizontalPadding)
            make.trailing.equalTo(view.snp.trailing).offset(-horizontalPadding)
            make.bottom.equalTo(mainScrollView.snp.bottom).offset(-verticalPadding)
        }
        
        let cell = UICollectionView.CellRegistration<TransactionCell, Transaction> { cell, indexPath, txn in
            cell.set(transaction: txn)
        }
        txnDataSource = UICollectionViewDiffableDataSource(collectionView: txnCollectionView) { collectionView, indexPath, txn in
            return collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: txn)
        }
    }
    
    func updateAccounts(_ accounts: [Account]) {
        
    }
    
    func updateTransactions(_ transactions: [Transaction]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Transaction>()
        snapshot.appendSections([.main])
        snapshot.appendItems(transactions)
        DispatchQueue.main.async { self.txnDataSource.apply(snapshot, animatingDifferences: true) }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

#Preview {
    HomeViewController(container: Container())
}
