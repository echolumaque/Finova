//
//  SceneDelegate.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/5/25.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let container = Container()
        _ = Assembler(
            [
                MainTabAssembly(),
                HomeAssembly(),
                StatisticsAssembly()
            ],
            container: container
        )
        
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        window?.rootViewController = container.resolve(MainTabRouter.self)?.view
        window?.makeKeyAndVisible()
    }
}
