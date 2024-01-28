//
//  SearchViewController.swift
//  SpotifyClone
//
//  Created by BearyCode on 16.11.23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var categories = [Category]()
    
    private let headerView = HeaderView()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private let searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.searchTextField.backgroundColor = .label
        searchbar.searchTextField.textColor = .black
        searchbar.searchTextField.attributedPlaceholder = NSAttributedString(string: "What do you want to listen to?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(1.0)])
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupHeaderView()
//        setupSearchBar()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSearchBar()
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        
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
        
        let trailing = searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        let leading = searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor)
        let bottom = searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        
        NSLayoutConstraint.activate([trailing, bottom, leading])
        
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        var currentTextFieldBounds = searchTextField?.bounds
        currentTextFieldBounds?.size.height = 130
        searchTextField?.bounds = currentTextFieldBounds ?? CGRect.zero
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.bounds.width/2.2, height: view.bounds.width/3.5)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        let top = collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/5)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func fetchData() {
        NetworkManager.shared.getCategories { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let requestedCategories):
                    self.categories = requestedCategories
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.layer.cornerRadius = 5
        cell.setContent(categoyName: categories[indexPath.row].name, iconURL: categories[indexPath.row].icons.first?.url)
        return cell
    }
    
    
}
