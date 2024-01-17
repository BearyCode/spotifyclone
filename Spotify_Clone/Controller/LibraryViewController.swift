//
//  LibraryViewController.swift
//  SpotifyClone
//
//  Created by BearyCode on 16.11.23.
//

import UIKit

class LibraryViewController: UIViewController {
    
    private let headerView = HeaderView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LibraryTableViewCell.self, forCellReuseIdentifier: LibraryTableViewCell.identifier)
        return tableView
    }()
    
    private let searchButton: UIButton = {
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addButton: UIButton = {
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playlistsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Playlists", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.backgroundColor = .filterBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Albums", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.backgroundColor = .filterBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let artistsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Artists", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.backgroundColor = .filterBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spotifyBackground
        setupTableView()
        setupHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAddButton()
        setupSearchButton()
        setupPlaylistsButton()
        setupAlbumsButton()
        setupArtistsButton()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let top = tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/5)
        let trailing = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        
        headerView.setTitle(title: "Your Library")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.layer.shadowColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0).cgColor
        headerView.layer.shadowOffset = CGSize(width: headerView.frame.width, height: 100)
        
        let top = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let trailing = headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor)
        let leading = headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
        
        headerView.addSubview(addButton)
        headerView.addSubview(searchButton)
        headerView.addSubview(playlistsButton)
        headerView.addSubview(albumsButton)
        headerView.addSubview(artistsButton)
    }
    
    private func setupAddButton() {
        let top = addButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10)
        let trailing = addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([top, trailing])
        
        if headerView.frame.height != 0 {
            let height = addButton.heightAnchor.constraint(equalToConstant: headerView.frame.height/4)
            let width = addButton.widthAnchor.constraint(equalToConstant: headerView.frame.height/4)
            
            NSLayoutConstraint.activate([width, height])
        }
    }
    
    private func setupSearchButton() {
        let top = searchButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10)
        let trailing = searchButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([top, trailing])
        
        if headerView.frame.height != 0 {
            let height = searchButton.heightAnchor.constraint(equalToConstant: headerView.frame.height/4)
            let width = searchButton.widthAnchor.constraint(equalToConstant: headerView.frame.height/4)
            
            NSLayoutConstraint.activate([width, height])
        }
    }
    
    private func setupPlaylistsButton() {
        let bottom = playlistsButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        let leading = playlistsButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, leading])
        
        if playlistsButton.frame.height != 0 {
            playlistsButton.layer.cornerRadius = playlistsButton.frame.height/2
        }
    }
    
    private func setupAlbumsButton() {
        let bottom = albumsButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        let leading = albumsButton.leadingAnchor.constraint(equalTo: playlistsButton.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, leading])
        
        if albumsButton.frame.height != 0 {
            albumsButton.layer.cornerRadius = albumsButton.frame.height/2
        }
    }
    
    private func setupArtistsButton() {
        let bottom = artistsButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        let leading = artistsButton.leadingAnchor.constraint(equalTo: albumsButton.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, leading])
        
        if artistsButton.frame.height != 0 {
            artistsButton.layer.cornerRadius = artistsButton.frame.height/2
        }
    }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/7-5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LibraryTableViewCell.identifier, for: indexPath) as! LibraryTableViewCell
        cell.selectionStyle = .none
        
        if indexPath.row % 2 == 0 {
            cell.isAlbum = true
        } else {
            cell.isAlbum = false
        }
        
        return cell
    }
    
    
}
