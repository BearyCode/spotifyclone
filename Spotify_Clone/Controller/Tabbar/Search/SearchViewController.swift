//
//  SearchViewController.swift
//  SpotifyClone
//
//  Created by BearyCode on 16.11.23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var categories = [Category]()
    private var currentUser: User? = nil
    
    private let headerView = MainViewControllerHeaderView()
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        return NSCollectionLayoutSection(group: group)
    }))

    private let searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "What do you want to listen to?"
        searchbar.searchBarStyle = .minimal
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupHeaderView()
        setupSearchBar()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupNavigationBar() {
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .spotifyBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        
        headerView.delegate = self
        headerView.setTitle(title: "Search")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let trailing = headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor)
        let leading = headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func setupSearchBar() {
        headerView.addSubview(searchBar)
        
        let top = searchBar.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 60)
        let trailing = searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let leading = searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, leading])
        searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/5)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func fetchData() {
        var loadedCategories: [Category]?
        var user: User?
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        NetworkManager.shared.getCategories { result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
                case .success(let requestedCategories):
                    loadedCategories = requestedCategories
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        NetworkManager.shared.getCurrentUserProfile { result in
            defer {
                dispatchGroup.leave()
            }
            
            switch result {
                case .success(let requestedUser):
                    user = requestedUser
                case .failure(let error):
                    print(error)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let loadedCategories = loadedCategories {
                self.categories = loadedCategories
            }
            
            self.currentUser = user
            self.headerView.setProfilePicture(urlString: self.currentUser?.images.first?.url, username: self.currentUser?.display_name)
            self.collectionView.reloadData()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, MainHeaderDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let vc = SearchResultViewController(searchQuery: searchBar.text)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.layer.cornerRadius = 5
        cell.setContent(categoyName: categories[indexPath.row].name, iconURL: categories[indexPath.row].icons.first?.url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryViewController(category: categories[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openProfile(_ sender: UIButton) {
        let vc = ProfileViewController(currentUser: currentUser)
        navigationController?.pushViewController(vc, animated: true)
    }
}
