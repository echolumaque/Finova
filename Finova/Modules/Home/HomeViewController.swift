//
//  HomeViewController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/8/25.
//

import CoreData
import UIKit
import SnapKit
import Swinject

protocol HomeView: AnyObject {
    var presenter: HomePresenter? { get set }
    func updateAccounts(_ accounts: [Account])
    func updateTransactions(_ transactions: [Transaction])
    func applySnapshot( _ snapshot: NSDiffableDataSourceSnapshot<Section, Transaction>)
}

class HomeViewController: UIViewController, HomeView {
    private let container: Resolver
    var presenter: HomePresenter?
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 8

    private lazy var txnCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayoutHelper.createVerticalCompositionalLayout(
            itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)),
            groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)),
            interGroupSpacing: 4,
            hasHeader: true
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
        
        configureTxnCollectionView()
        configureCashflowInsertView()
        
        Task { [weak self] in
            guard let self else { return }
//            await presenter?.getPredefinedAccounts()
//            await presenter?.getPrdefinedTransactions()
            
            await presenter?.getAccounts()
            await presenter?.getTransactions()
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
    
//    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
//        var config = UIContentUnavailableConfiguration.empty()
//        config.image = UIImage(resource: .customDollarsignBankBuildingSlashFill)
//        config.text = "No transactions"
//        config.secondaryText = "There are no recent transactions found."
//        
//        guard let presenter else {
//            contentUnavailableConfiguration = config
//            return
//        }
//    }
    
    private func configureTxnCollectionView() {
        txnCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(txnCollectionView)
        txnCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        let cell = UICollectionView.CellRegistration<TransactionCell, Transaction> { cell, indexPath, txn in
            cell.set(transaction: txn)
        }
        txnDataSource = UICollectionViewDiffableDataSource(collectionView: txnCollectionView) { collectionView, indexPath, txn in
            return collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: txn)
        }
        
        // Register the header class
        txnCollectionView.register(
            AccountSummaryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AccountSummaryHeaderView.reuseId
        )
        
        // Tell the data source how to dequeue it
        txnDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: AccountSummaryHeaderView.reuseId,
                for: indexPath
            ) as! AccountSummaryHeaderView
            
            return header
        }
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
    
    func updateAccounts(_ accounts: [Account]) {
        
    }
    
    func updateTransactions(_ transactions: [Transaction]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Transaction>()
        snapshot.appendSections([.main])
        snapshot.appendItems(transactions)
        DispatchQueue.main.async { self.txnDataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<Section, Transaction>) {
        DispatchQueue.main.async { self.txnDataSource.apply(snapshot, animatingDifferences: true) }
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
