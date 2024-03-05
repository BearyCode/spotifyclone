//
//  SearchResultViewController.swift
//  Spotify_Clone
//
//  Created by BearyCode on 21.02.24.
//

import UIKit

enum SearchResultSectionType {
    case track(tracks: [Track])
    case artist(artists: [Artist])
    case album(albums: [Album])
    case playlist(playlists: [Playlist])
}

class SearchResultViewController: UIViewController {
    
    private var searchQuery: String?
    
    private var sections = [SearchResultSectionType]()
    
    private let searchController: UISearchController = {
        let searchcontroller = UISearchController()
        searchcontroller.searchBar.placeholder = "What do you want to listen to?"
        searchcontroller.searchBar.searchBarStyle = .minimal
        searchcontroller.searchBar.barStyle = .black
        searchcontroller.searchBar.tintColor = .white
        searchcontroller.hidesNavigationBarDuringPresentation = false
        searchcontroller.definesPresentationContext = true
        return searchcontroller
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SearchResultSongTableViewCell.self, forCellReuseIdentifier: SearchResultSongTableViewCell.identifier)
        tableView.register(LibraryArtistTableViewCell.self, forCellReuseIdentifier: LibraryArtistTableViewCell.identifier)
        tableView.register(LibraryAlbumTableViewCell.self, forCellReuseIdentifier: LibraryAlbumTableViewCell.identifier)
        tableView.register(LibraryPlaylistTableViewCell.self, forCellReuseIdentifier: LibraryPlaylistTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(searchQuery: String?) {
        self.searchQuery = searchQuery
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        fetchData(searchQuery)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .spotifyBackground
    }
    
    private func setupNavigationBar() {
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .spotifyBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        navigationItem.searchController = searchController
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let top = tableView.topAnchor.constraint(equalTo: view.topAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    func fetchData(_ searchQuery: String?) {//(_ searchResults: SearchResultResponse) {
        
        guard let query = searchQuery, !query.isEmpty else {
            return
        }
        
        let cleanedQuery = query.trimmingCharacters(in: .whitespaces)
        sections = [SearchResultSectionType]()
        
        NetworkManager.shared.getSearchResults(query: cleanedQuery) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let searchResult):
                        self.sections.append(.track(tracks: searchResult.tracks.items))
                        self.sections.append(.artist(artists: searchResult.artists.items))
                        self.sections.append(.album(albums: searchResult.albums.items))
                        self.sections.append(.playlist(playlists: searchResult.playlists.items))
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = sections[section]
        
        switch sec {
        case .track(let tracks):
            return tracks.count
            
        case .artist(let artists):
            return artists.count
            
        case .album(let albums):
            return albums.count
            
        case .playlist(let playlists):
            return playlists.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sec = sections[section]
        
        switch sec {
        case .track:
            return "Songs"
        case .artist:
            return "Artists"
        case .album:
            return "Albums"
        case .playlist:
            return " Playlists"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sec = sections[indexPath.section]
        
        switch sec {
            case .track(let tracks):
                let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSongTableViewCell.identifier, for: indexPath) as! SearchResultSongTableViewCell
                cell.setContent(imageURL: tracks[indexPath.row].album?.images.first?.url, songTitle: tracks[indexPath.row].name, artistName: tracks[indexPath.row].artists.first?.name)
                cell.selectionStyle = .none
                return cell
            case .artist(let artists):
                let cell = tableView.dequeueReusableCell(withIdentifier: LibraryArtistTableViewCell.identifier, for: indexPath) as! LibraryArtistTableViewCell
                cell.setContent(imageURL: artists[indexPath.row].images?.first?.url, artistName: artists[indexPath.row].name)
                cell.selectionStyle = .none
                return cell
            case .album(let albums):
                let cell = tableView.dequeueReusableCell(withIdentifier: LibraryAlbumTableViewCell.identifier, for: indexPath) as! LibraryAlbumTableViewCell
                cell.setContent(imageURL: albums[indexPath.row].images.first?.url, albumTitle: albums[indexPath.row].name, artistName: albums[indexPath.row].artists.first?.name)
                cell.selectionStyle = .none
                return cell
            case .playlist(let playlists):
                let cell = tableView.dequeueReusableCell(withIdentifier: LibraryPlaylistTableViewCell.identifier, for: indexPath) as! LibraryPlaylistTableViewCell
                cell.setContent(imageURL: playlists[indexPath.row].images.first?.url, playlistName: playlists[indexPath.row].name, numberOfSongs: playlists[indexPath.row].tracks.total)
                cell.selectionStyle = .none
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sec = sections[indexPath.section]
        
        switch sec {
            case .track(let tracks):
                print("Playing \(tracks[indexPath.row].name) von \(tracks[indexPath.row].artists.first!.name)")
            case .artist(let artists):
                let vc = ArtistViewController(artist: artists[indexPath.row])
                navigationController?.pushViewController(vc, animated: true)
            case .album(let albums):
                let vc = AlbumViewController(album: albums[indexPath.row])
                navigationController?.pushViewController(vc, animated: true)
            case .playlist(let playlists):
                let vc = PlaylistViewController(playlist: playlists[indexPath.row])
                navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchResultViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        fetchData(searchController.searchBar.text)
    }
}
