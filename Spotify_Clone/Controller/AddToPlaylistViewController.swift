//
//  AddPlaylistViewController.swift
//  Spotify_Clone
//
//  Created by BearyCode on 15.03.24.
//

import UIKit

class AddToPlaylistViewController: UIViewController {
    
    private var playlists = [Playlist]()
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .clear
        tableview.register(LibraryPlaylistTableViewCell.self, forCellReuseIdentifier: LibraryAlbumTableViewCell.identifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spotifyBackground
        setupTableView()
        fetchData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let top = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func fetchData() {
        DispatchQueue.main.async {
            NetworkManager.shared.getUserSavedPlaylists { result in
                switch result {
                case .success(let requestedPlaylists):
                    self.playlists = requestedPlaylists
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension AddToPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LibraryPlaylistTableViewCell.identifier, for: indexPath) as! LibraryPlaylistTableViewCell
        cell.setContent(imageURL: playlists[indexPath.row].images.first?.url, playlistName: playlists[indexPath.row].name, numberOfSongs: playlists[indexPath.row].tracks.total)
        return cell
    }
    
    
}
