//
//  TabBarViewController.swift
//  SpotifyClone
//
//  Created by BearyCode on 16.11.23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private let homeVC = HomeViewController()
    
    private let searchVC = SearchViewController()
    
    private let libraryVC = LibraryViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let homeNav = UINavigationController(rootViewController: homeVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let libraryNav = UINavigationController(rootViewController: libraryVC)
        
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        libraryNav.tabBarItem = UITabBarItem(title: "Your Library", image: UIImage(systemName: "square.stack.3d.down.right", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)), tag: 2)
  
        tabBar.tintColor = .white
        tabBar.barTintColor = .clear
        setViewControllers([homeNav, searchNav, libraryNav], animated: true)
    }
}

