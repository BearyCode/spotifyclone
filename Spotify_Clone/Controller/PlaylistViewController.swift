//
//  PlaylistViewController.swift
//  Spotify_Clone
//
//  Created by BearyCode on 22.01.24.
//

import UIKit

class PlaylistViewController: UIViewController {
    private let playlist: Playlist
    private var details: PlaylistDetails?
    private var tracks = [Track]()
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.1)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        
        return section
    })
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .clear
    }
    
    private func setupNavigationBar() {
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .spotifyBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func fetchData() {
        NetworkManager.shared.getPlaylistTracks(playlist: playlist) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let requestedPlaylist):
                    self.details = requestedPlaylist
                    self.tracks = requestedPlaylist.tracks.items.compactMap({$0.track})
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error)
                }
            }
        }
    }
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource, PlaylistHeaderActionsDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        header.delegate = self
        header.setContent(description: playlist.description, owner: playlist.owner.display_name, followers: details?.followers.total ?? 0, coverImageURL: playlist.images.first?.url)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as! AlbumTrackCollectionViewCell
        
        if let artist = tracks[indexPath.row].artists.first {
            cell.setContent(title: tracks[indexPath.row].name, artist: artist.name)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        let vc = PlayerViewController(track: track, coverURLString: playlist.images.first?.url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func playAllTracks(_ sender: UIButton) {
        let vc = PlayerViewController(tracks: tracks, coverURLString: playlist.images.first?.url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func savePlaylist(_ sender: UIButton) {
        NetworkManager.shared.savePlaylist(playlist: playlist) { success in
            if success {
                print("\(self.playlist.name) added")
            } else {
                print("Failed")
            }
        }
    }
}
