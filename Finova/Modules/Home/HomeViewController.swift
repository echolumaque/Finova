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
}

class HomeViewController: UIViewController, HomeView {
    let container: Resolver
    var presenter: HomePresenter?
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 8
    
    private var accountsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayoutHelper.createHorizontalCompositionalLayout(
            itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150)),
            groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150)),
            interGroupSpacing: 8
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
        
        configureAccounts()
    }
    
    private func configureAccounts() {
       
    }
}

#Preview {
    HomeViewController(container: Container())
}
