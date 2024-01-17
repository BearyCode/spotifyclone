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
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        libraryVC.tabBarItem = UITabBarItem(title: "Your Library", image: UIImage(systemName: "square.stack.3d.down.right", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)), tag: 2)
        
        UITabBar.appearance().tintColor = .white
        
        setViewControllers([homeVC, searchVC, libraryVC], animated: true)
    }
}

