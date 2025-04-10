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
    
    private var profilePicture = UIImageView()
    
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
    }
    
    private func configureAccount() {
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.clipsToBounds = true
        profilePicture.layer.cornerRadius = 45 / 2
        profilePicture.layer.borderColor = UIColor(rgb: 0x111184).cgColor
        profilePicture.layer.borderWidth = 2
        profilePicture.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate)
        profilePicture.tintColor = UIColor(rgb: 0x111184)
        
        view.addSubview(profilePicture)
        NSLayoutConstraint.activate([
            profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            profilePicture.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            profilePicture.widthAnchor.constraint(equalToConstant: 45),
            profilePicture.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}

#Preview {
    HomeViewController(container: Container())
}
