//
//  SceneDelegate.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 29.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupWindow(scene: scene)
    }
    
    private func setupWindow(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let assembly = Assembly()
        let rootVC = assembly.configureMainModule()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }
}

