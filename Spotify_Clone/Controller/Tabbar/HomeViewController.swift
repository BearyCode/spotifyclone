//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by BearyCode on 16.11.23.
//

import UIKit

enum HomeSectionType {
    case featuredPlaylists(featuredPlaylists: [Playlist])
    case newReleases(newReleasedAlbums: [Album])
    case recommendedTracks(recommendedTracks: [Track])
}

class HomeViewController: UIViewController {

    private var playlists: [Playlist] = []
    private var albums: [Album] = []
    private var tracks: [Track] = []
    private var currentUser: User? = nil
    
    private let headerView = MainViewControllerHeaderView()
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return HomeViewController.createSectionsLayout(section: sectionIndex)
    })
    
    private var sections = [HomeSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupHeaderView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private static func createSectionsLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48), heightDimension: .absolute(200)), subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
            
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48), heightDimension: .absolute(200)), subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
            
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400)), subitem: item, count: 1)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.96), heightDimension: .absolute(300)), subitem: horizontalGroup, count: 4)
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
            
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48), heightDimension: .absolute(200)), subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        }
    }
    
    private func setupNavigationBar() {
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .spotifyBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    private func setupCollectionView() {
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(NewReleasedAlbumCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasedAlbumCollectionViewCell.identifier)
        collectionView.register(RecommandedTracksCollectionViewCell.self, forCellWithReuseIdentifier: RecommandedTracksCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        let top = collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/8)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        
        headerView.delegate = self
        headerView.setTitle(title: "")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let trailing = headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor)
        let leading = headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func fetchData() {
        var featurePlaylist: FeaturedPlaylist?
        var newReleasedAlbums: NewReleases?
        var recommendedTracks: CustomTracksResponse?
        var user: User?
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        NetworkManager.shared.getFeaturedPlaylists { result in
            defer {
                dispatchGroup.leave()
            }
            
            switch result {
            case .success(let requestedPlaylists):
                featurePlaylist = requestedPlaylists
            case .failure(let error):
                print(error)
            }
        }
        
        NetworkManager.shared.getNewAlbumReleases { result in
            defer {
                dispatchGroup.leave()
            }
            
            switch result {
            case .success(let requestedAlbums):
                newReleasedAlbums = requestedAlbums
            case .failure(let error):
                print(error)
            }
        }
        
        NetworkManager.shared.getRecomendedGenres { result in
            switch result {
                case .success(let recommendedGenres):
                    let genres = recommendedGenres.genres
                    var seeds = Set<String>()
                    
                    while seeds.count < 5 {
                        if let random = genres.randomElement() {
                            seeds.insert(random)
                        }
                    }
                    
                NetworkManager.shared.getRecomendedTracks(genres: seeds) { result in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    switch result {
                        case .success(let tracks):
                            recommendedTracks = tracks
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
        
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
            guard let featPlaylists = featurePlaylist?.playlists.items, let newAlbums = newReleasedAlbums?.albums.items, let recomTracks = recommendedTracks?.tracks, let user = user else {
                return
            }
            
            self.currentUser = user
            self.headerView.setProfilePicture(urlString: self.currentUser?.images.first?.url, username: self.currentUser?.display_name)
            
            self.configureSectionsData(loadedPlaylists: featPlaylists, loadedAlbums: newAlbums, loadedTracks: recomTracks)
        }
        
        
    }
    
    private func configureSectionsData(loadedPlaylists: [Playlist], loadedAlbums: [Album], loadedTracks: [Track]) {
        playlists = loadedPlaylists
        albums = loadedAlbums
        tracks = loadedTracks
        
        sections.append(.featuredPlaylists(featuredPlaylists: loadedPlaylists))
        sections.append(.newReleases(newReleasedAlbums: loadedAlbums))
        sections.append(.recommendedTracks(recommendedTracks: loadedTracks))
        
        collectionView.reloadData()
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, MainHeaderDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let selectedSection = sections[section]
        
        switch selectedSection {
        case .featuredPlaylists(let featPlaylists): 
            return featPlaylists.count
        case .newReleases(let newAlbums): 
            return newAlbums.count
        case .recommendedTracks(let recTracks): 
            return recTracks.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .featuredPlaylists(let playlists):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as! FeaturedPlaylistCollectionViewCell
            cell.setContent(title: playlists[indexPath.row].name, coverImageURL: playlists[indexPath.row].images.first?.url)
            return cell
        case .newReleases(let albums):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasedAlbumCollectionViewCell.identifier, for: indexPath) as! NewReleasedAlbumCollectionViewCell
            cell.setContent(title: albums[indexPath.row].name, artist: albums[indexPath.row].artists[0].name, coverImageURL: albums[indexPath.row].images.first?.url)
            return cell
        case .recommendedTracks(let tracks):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandedTracksCollectionViewCell.identifier, for: indexPath) as! RecommandedTracksCollectionViewCell
            if let album = tracks[indexPath.row].album {
                cell.setContent(title: tracks[indexPath.row].name, artist: tracks[indexPath.row].artists.first?.name ?? "", coverImageURL: album.images.first?.url)
            }
            cell.clipsToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as? CollectionHeaderReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        var headerTitle: String
        
        switch sections[section] {
        case .featuredPlaylists: 
            headerTitle = "Featured Playlists"
        case .newReleases:
            headerTitle = "New Releases"
        case .recommendedTracks: 
            headerTitle = "Recommended Tacks"
        }
        
        header.setHeaderTitle(title: headerTitle)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        
        switch section {
        case .featuredPlaylists:
            let featPlaylist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: featPlaylist)
            navigationController?.pushViewController(vc, animated: true)
        case .newReleases:
            let newAlbum = albums[indexPath.row]
            let vc = AlbumViewController(album: newAlbum)
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks:
            let recomTrack = tracks[indexPath.row]
            let vc = PlayerViewController(track: recomTrack, coverURLString: recomTrack.album?.images.first?.url)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openProfile(_ sender: UIButton) {
        let vc = ProfileViewController(currentUser: currentUser)
        navigationController?.pushViewController(vc, animated: true)
    }
}
