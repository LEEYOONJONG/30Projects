//
//  SceneDelegate.swift
//  Outstagram
//
//  Created by YOONJONG on 2022/05/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = FeedViewController()
        window?.makeKeyAndVisible()
        window?.rootViewController = TabBarController()
        window?.tintColor = .label
    }

    


}

