//
//  LibraryViewController.swift
//  SpotifyClone
//
//  Created by BearyCode on 16.11.23.
//

import UIKit

enum LibrarySectionType {
    case savedPlaylists(savedPlaylists: [Playlist])
    case savedArtists(savedArtists: [Artist])
    case savedAlbums(savedAlbums: [Album])
}

class LibraryViewController: UIViewController {
    
    private var playlists = [Playlist]()
    private var artists = [Artist]()
    private var albums = [Album]()
    
    private var sections = [LibrarySectionType]()
    
    private let headerView = MainViewControllerHeaderView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LibraryPlaylistTableViewCell.self, forCellReuseIdentifier: LibraryPlaylistTableViewCell.identifier)
        tableView.register(LibraryArtistTableViewCell.self, forCellReuseIdentifier: LibraryArtistTableViewCell.identifier)
        tableView.register(LibraryAlbumTableViewCell.self, forCellReuseIdentifier: LibraryAlbumTableViewCell.identifier)
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
        setupNavigationBar()
        setupTableView()
        setupHeaderView()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAddButton()
        setupSearchButton()
        setupPlaylistsButton()
        setupAlbumsButton()
        setupArtistsButton()
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
    
    private func fetchData() {
        
        var usersPlaylists = [Playlist]()
        var usersArtists = [Artist]()
        var usersAlbums = [Album]()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        NetworkManager.shared.getUserSavedPlaylists { result in
            defer {
                dispatchGroup.leave()
            }
                switch result {
                case .success(let requestedPlaylists):
                    usersPlaylists = requestedPlaylists
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        
        NetworkManager.shared.getUserSavedArtists { result in
            defer {
                dispatchGroup.leave()
            }
            
            switch result {
                case .success(let requestedArtists):
                    usersArtists = requestedArtists
                case .failure(let error):
                    print(error.localizedDescription)
                }
            
        }
        
        NetworkManager.shared.getUserSavedAlbums { result in
            defer {
                dispatchGroup.leave()
            }
                switch result {
                case .success(let requestedAlbums):
                    usersAlbums = requestedAlbums
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.configureSectionsData(loadedPlaylists: usersPlaylists, loadedArtists: usersArtists, loadedAlbums: usersAlbums)
        }
    }
    
    private func configureSectionsData(loadedPlaylists: [Playlist], loadedArtists: [Artist], loadedAlbums: [Album]) {
        playlists = loadedPlaylists
        artists = loadedArtists
        albums = loadedAlbums
        
        sections.append(.savedPlaylists(savedPlaylists: loadedPlaylists))
        sections.append(.savedArtists(savedArtists: loadedArtists))
        sections.append(.savedAlbums(savedAlbums: loadedAlbums))
        
        tableView.reloadData()
    }
    
    @objc private func filterButtonTapped(sender _: UIButton) {
        
    }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/7-5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedSection = sections[section]
        
        switch selectedSection {
        case .savedPlaylists(let playlists):
            return playlists.count
        case .savedAlbums(let albums):
            return albums.count
        case .savedArtists(let artists):
            return artists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
            case .savedPlaylists(let playlists):
                let cell = tableView.dequeueReusableCell(withIdentifier: LibraryPlaylistTableViewCell.identifier, for: indexPath) as! LibraryPlaylistTableViewCell
                cell.setContent(imageURL: playlists[indexPath.row].images.first?.url, playlistName: playlists[indexPath.row].name, numberOfSongs: playlists[indexPath.row].tracks.total)
                cell.selectionStyle = .none
                return cell
            case .savedArtists(let artists):
                let cell = tableView.dequeueReusableCell(withIdentifier: LibraryArtistTableViewCell.identifier, for: indexPath) as! LibraryArtistTableViewCell
                cell.setContent(imageURL: artists[indexPath.row].images?.first?.url, artistName: artists[indexPath.row].name)
                cell.selectionStyle = .none
                return cell
            case .savedAlbums(savedAlbums: let albums):
                let cell = tableView.dequeueReusableCell(withIdentifier: LibraryAlbumTableViewCell.identifier, for: indexPath) as! LibraryAlbumTableViewCell
                cell.setContent(imageURL: albums[indexPath.row].images.first?.url, albumTitle: albums[indexPath.row].name, artistName: albums[indexPath.row].artists.first?.name)
                cell.selectionStyle = .none
                return cell
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .savedPlaylists(savedPlaylists: let playlists):
            let vc = PlaylistViewController(playlist: playlists[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        case .savedArtists(savedArtists: let artists):
            let vc = ArtistViewController(artist: artists[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        case .savedAlbums(savedAlbums: let albums):
            let vc = AlbumViewController(album: albums[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
