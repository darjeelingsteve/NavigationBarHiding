//
//  SceneDelegate.swift
//  NavigationBarHiding
//
//  Created by Stephen Anthony on 01/05/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let splitViewController = UISplitViewController(style: .doubleColumn)
        splitViewController.preferredDisplayMode = .oneBesideSecondary
        splitViewController.preferredSplitBehavior = .tile
        splitViewController.setViewController(UIViewController(), for: .primary)
        splitViewController.setViewController(NavigationBarBackgroundHidingNavigationController(rootViewController: NumbersViewController(style: .grouped)), for: .secondary)
        splitViewController.setViewController(NavigationBarBackgroundHidingNavigationController(rootViewController: NumbersViewController(style: .grouped)), for: .compact)
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
    }
}
