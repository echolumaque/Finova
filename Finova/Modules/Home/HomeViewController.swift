//
//  HomeViewController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import CoreData
import UIKit
import RxSwift
import SnapKit
import Swinject

protocol HomeView: AnyObject {
    var presenter: HomePresenter? { get set }
    func updateTransactions(_ transactions: [TransactionCellViewModel])
}

class HomeViewController: UIViewController, HomeView {
    private let container: Resolver
    var presenter: HomePresenter?
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 8

    private let containerStackView = UIStackView(frame: .zero)
    private let helperStackView = UIStackView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let accountMenuStackView = UIStackView(frame: .zero)
    private let accountStackView = UIStackView(frame: .zero)
    private let recentTxnLabel = DynamicLabel(textColor: .black, font: UIFont.preferredFont(for: .title2, weight: .semibold))
    private let frequencySegmentedControl = UISegmentedControl(frame: .zero)
    private let txnCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayoutHelper.createVerticalCompositionalLayout(
            itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)),
            groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)),
            interGroupSpacing: 4,
            hasHeader: false
        )
    )
    private var txnDataSource: UICollectionViewDiffableDataSource<Section, TransactionCellViewModel>!
    
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
        
        configureContainerStackView()
        configureHeaderView()
        configureTxnCollectionView()
        configureCashflowInsertView()
        
        Task { [weak self] in
            guard let self else { return }
//            await presenter?.getPredefinedAccounts()
//            await presenter?.getPrdefinedTransactions()
            
//            await presenter?.getAccounts()
            await presenter?.fetchInitialTxns()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
//        var config = UIContentUnavailableConfiguration.empty()
//        config.image = UIImage(resource: .customDollarsignBankBuildingSlashFill)
//        config.text = "No transactions"
//        config.secondaryText = "There are no recent transactions found."
//        
//        guard let presenter else {
//            contentUnavailableConfiguration = config
//            return
//        }
    }
    
    private func configureContainerStackView() {
        containerStackView.axis = .vertical
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureHeaderView() {
        configureHelperStackView()
        configureAccountContainerView()
        configureAccountStackView()
        configureMenuStackView()
        configureAccountBalanceAndName()
        configureCashflowBadges()
        configureRecentTxnLabel()
        configureFrequencySegmentedControl()
        helperStackView.addArrangedSubview(SpacerView())
    }
    
    private func configureHelperStackView() {
        helperStackView.axis = .vertical
        helperStackView.alignment = .fill
        helperStackView.translatesAutoresizingMaskIntoConstraints = false
        helperStackView.layoutMargins = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        helperStackView.isLayoutMarginsRelativeArrangement = true
        
        containerStackView.addArrangedSubview(helperStackView)
        helperStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
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
            make.top.equalTo(containerStackView.safeAreaLayoutGuide.snp.top)
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
        accountBtn.showsMenuAsPrimaryAction = true
        accountBtn.menu = UIMenu(options: .singleSelection, children: [
            UIDeferredMenuElement.uncached { [weak self] completion  in
                Task { [weak self] in
                    guard let self, let presenter else { return }
                    
                    let actions = await presenter.getAccountsMenuData()
                    completion(actions)
                }
            }
        ])
        
        accountMenuStackView.addSubview(accountBtn)
        accountBtn.pinToEdges(of: accountMenuStackView)
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
        accountBalance.text = "\(Locale.current.currencySymbol ?? "$")5,000.00"
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
    
    private func configureTxnCollectionView() {
//        let header = AccountSummaryHeaderView(frame: .zero)
//        header.translatesAutoresizingMaskIntoConstraints = false
//        containerStackView.addArrangedSubview(header)
        
        txnCollectionView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.addArrangedSubview(txnCollectionView)
        txnCollectionView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(containerStackView.safeAreaLayoutGuide.snp.bottom)
        }
        
        let cell = UICollectionView.CellRegistration<TransactionCell, TransactionCellViewModel> { cell, indexPath, txnVm in
            cell.set(txnVm: txnVm)
        }
        txnDataSource = UICollectionViewDiffableDataSource(collectionView: txnCollectionView) { collectionView, indexPath, txn in
            return collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: txn)
        }
        
//        // Register the header class
//        txnCollectionView.register(
//            AccountSummaryHeaderView.self,
//            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: AccountSummaryHeaderView.reuseId
//        )
//        
//        // Tell the data source how to dequeue it
//        txnDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
//            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
//            
//            let header = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: AccountSummaryHeaderView.reuseId,
//                for: indexPath
//            ) as! AccountSummaryHeaderView
//            
//            return header
//        }
    }
    
    private func configureCashflowInsertView() {
        let cashflowInsertView = CashflowInsertView(frame: .zero)
        cashflowInsertView.delegate = self
        view.addSubview(cashflowInsertView)
        cashflowInsertView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview { $0.safeAreaLayoutGuide }.inset(16)
            make.size.equalTo(50)
        }
    }
    
    @objc func frequencyDidChange(_ segmentedControl: UISegmentedControl) {
//        segmentedControl.selectedSegmentIndex
    }
    
    
    func updateTransactions(_ transactions: [TransactionCellViewModel]) {
        guard var currentSnapshot = txnDataSource?.snapshot() else { return }
        if currentSnapshot.indexOfSection(.main) == nil {
            currentSnapshot.appendSections([.main])
        }
        
        currentSnapshot.appendItems(transactions, toSection: .main)
        DispatchQueue.main.async {
            self.txnDataSource?.apply(currentSnapshot, animatingDifferences: true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: CashflowInsertViewDelegate {
    func onTapped(cashflowType: CashflowType) {
        presenter?.gotoAddCashflow(cashflowType: cashflowType)
    }
}
#Preview {
    HomeViewController(container: Container())
}
