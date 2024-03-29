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

    private var numberOfPlaylists = 0
    private var numberOfArtists = 0
    private var numberOfAlbums = 0
    
    private var playlists = [Playlist]()
    private var artists = [Artist]()
    private var albums = [Album]()
    private var currentUser: User? = nil
    
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
    
    private let addButton: UIButton = {
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.addTarget(self, action: #selector(createNewPlaylist(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let allButton: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.backgroundColor = .spotifyGreen
        button.setTitleColor(.black, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        button.tag = 0
        button.isSelected = true
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
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        button.tag = 1
        button.isSelected = false
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
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        button.tag = 2
        button.isSelected = false
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
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        button.tag = 3
        button.isSelected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAddButton()
        setupAllButton()
        setupPlaylistsButton()
        setupArtistsButton()
        setupAlbumsButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        fetchData()
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
        
        headerView.delegate = self
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
        headerView.addSubview(allButton)
        headerView.addSubview(playlistsButton)
        headerView.addSubview(artistsButton)
        headerView.addSubview(albumsButton)
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
    
    private func setupAllButton() {
        let bottom = allButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        let leading = allButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, leading])
        
        if allButton.frame.height != 0 {
            allButton.layer.cornerRadius = allButton.frame.height/2
        }
    }
    
    private func setupPlaylistsButton() {
        let bottom = playlistsButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        let leading = playlistsButton.leadingAnchor.constraint(equalTo: allButton.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, leading])
        
        if playlistsButton.frame.height != 0 {
            playlistsButton.layer.cornerRadius = playlistsButton.frame.height/2
        }
    }
    
    private func setupArtistsButton() {
        let bottom = artistsButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        let leading = artistsButton.leadingAnchor.constraint(equalTo: playlistsButton.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, leading])
        
        if artistsButton.frame.height != 0 {
            artistsButton.layer.cornerRadius = artistsButton.frame.height/2
        }
    }
    
    private func setupAlbumsButton() {
        let bottom = albumsButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        let leading = albumsButton.leadingAnchor.constraint(equalTo: artistsButton.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, leading])
        
        if albumsButton.frame.height != 0 {
            albumsButton.layer.cornerRadius = albumsButton.frame.height/2
        }
    }
    
    private func fetchData() {
        var usersPlaylists = [Playlist]()
        var usersArtists = [Artist]()
        var usersAlbums = [Album]()
        var user: User?
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
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
            self.currentUser = user
            self.headerView.setProfilePicture(urlString: self.currentUser?.images.first?.url, username: self.currentUser?.display_name)
            self.sections = [LibrarySectionType]()
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
        
        numberOfPlaylists = loadedPlaylists.count
        numberOfArtists = loadedArtists.count
        numberOfAlbums = loadedAlbums.count
        
        tableView.reloadData()
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        let buttons = [allButton, playlistsButton, artistsButton, albumsButton]
        
        buttons.forEach { button in
            button.isSelected = button.tag == sender.tag ? true : false;
            button.backgroundColor = button.tag == sender.tag ? .spotifyGreen : .filterBackground
            button.setTitleColor(button.tag == sender.tag ? .black : .white, for: .normal)
        }
        
        switch sender.tag {
            case 0:
                numberOfPlaylists = sender.isSelected ? playlists.count : 0
                numberOfArtists = sender.isSelected ? artists.count : 0
                numberOfAlbums = sender.isSelected ? albums.count : 0
            case 1:
                numberOfPlaylists = sender.isSelected ? playlists.count : 0
                numberOfArtists = 0
                numberOfAlbums = 0
            case 2:
                numberOfPlaylists = 0
                numberOfArtists = sender.isSelected ? artists.count : 0
                numberOfAlbums = 0
            case 3:
                numberOfPlaylists = 0
                numberOfArtists = 0
                numberOfAlbums = sender.isSelected ? albums.count : 0
            default:
                break
        }
        
        tableView.reloadData()
    }
    
    @objc private func createNewPlaylist(_ sender: UIButton) {
        let alert = UIAlertController(title: "Create new playlist", message: nil, preferredStyle: .alert)
        
        var playlistNameTextField = UITextField()
        
        let action = UIAlertAction(title: "Create", style: .default) { action in
            guard let textField = alert.textFields?.first, let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            
            NetworkManager.shared.createPlaylist(playlistName: text) { success in
                if success {
                    self.fetchData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { cancelAction in    }
        
        alert.addTextField { textField in
            playlistNameTextField = textField
            playlistNameTextField.placeholder = "Playlist name"
        }
        
        alert.overrideUserInterfaceStyle = .dark
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource, MainHeaderDelegate {
    
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
                return numberOfAlbums
            case .savedArtists(let artists):
                return numberOfArtists
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
    
    func openProfile(_ sender: UIButton) {
        let vc = ProfileViewController(currentUser: currentUser)
        navigationController?.pushViewController(vc, animated: true)
    }
}
