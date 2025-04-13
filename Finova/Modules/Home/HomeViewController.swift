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
    
    private let accountsLabel = DynamicLabel(textColor: .label, font: UIFont.preferredFont(for: .title2, weight: .bold))
    private var accountsDataSource: UICollectionViewDiffableDataSource<Section, Account>!
    private lazy var accountsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayoutHelper.createHorizontalCompositionalLayout(
            size: NSCollectionLayoutSize(widthDimension: .estimated(180), heightDimension: .estimated(150)),
            interGroupSpacing: horizontalPadding
        )
    )
    
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
        
        configureAccountsLabel()
        configureAccounts()
        configureIncomeExpenses()
        
        Task { [weak self] in
            guard let self else { return }
            await presenter?.getPredefinedAccounts()
        }
    }
    
    private func configureAccountsLabel() {
        accountsLabel.text = "Available Accounts"
        view.addSubview(accountsLabel)
        NSLayoutConstraint.activate([
            accountsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            accountsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            accountsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding)
        ])
    }
    
    private func configureAccounts() {
        accountsCollectionView.delegate = self
        accountsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountsCollectionView)
        NSLayoutConstraint.activate([
            accountsCollectionView.topAnchor.constraint(equalTo: accountsLabel.bottomAnchor, constant: verticalPadding),
            accountsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            accountsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            accountsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        let accountCell = UICollectionView.CellRegistration<AccountCell, Account> { cell, indexPath, account in
            cell.set(account: account)
        }
        accountsDataSource = UICollectionViewDiffableDataSource(collectionView: accountsCollectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: accountCell, for: indexPath, item: item)
        }
    }
    
    private func configureIncomeExpenses() {
        
    }
    
    func updateAccounts(_ accounts: [Account])  {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Account>()
        snapshot.appendSections([.main])
        snapshot.appendItems(accounts)
        DispatchQueue.main.async {
            self.accountsDataSource.apply(snapshot, animatingDifferences: true) {
                self.accountsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

#Preview {
    HomeViewController(container: Container())
}
