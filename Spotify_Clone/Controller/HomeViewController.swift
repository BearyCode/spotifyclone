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
    case popularArtists
    
    var title: String {
        switch self {
        case .featuredPlaylists: return "Featured Playlists"
        case .newReleases: return "New Releases"
        case .popularArtists: return "Popular artists"
        }
    }
}

class HomeViewController: UIViewController {
    
    private var playlists: [Playlist] = []
    private var albums: [Album] = []
    
    private let headerView = HeaderView()
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return HomeViewController.createSectionsLayout(section: sectionIndex)
    })
    
    private var sections = [HomeSectionType]()
    
    private lazy var allButton: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.backgroundColor = .filterBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var musicButton: UIButton = {
        let button = UIButton()
        button.setTitle("Music", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.backgroundColor = .filterBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var podcastsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Podcasts", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.backgroundColor = .filterBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spotifyBackground
        setupCollectionView()
        setupHeaderView()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPodcastsButton()
        setupMusicButton()
        setupAllButton()
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
    
    private func setupCollectionView() {
        collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
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
        
        headerView.setTitle(title: "")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let trailing = headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor)
        let leading = headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
        headerView.addSubview(podcastsButton)
        headerView.addSubview(musicButton)
        headerView.addSubview(allButton)
    }
    
    private func setupAllButton() {
        let top = allButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10)
        let bottom = allButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5)
        let trailing = allButton.leadingAnchor.constraint(equalTo: headerView.customLeadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, bottom, trailing])
        
        if allButton.frame.height != 0 {
            allButton.layer.cornerRadius = allButton.frame.height/2
        }
    }
    
    private func setupMusicButton() {
        let top = allButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10)
        let bottom = musicButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5)
        let trailing = musicButton.leadingAnchor.constraint(equalTo: allButton.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, trailing])
        
        if musicButton.frame.height != 0 {
            musicButton.layer.cornerRadius = musicButton.frame.height/2
        }
    }
    
    private func setupPodcastsButton() {
        let top = allButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10)
        let bottom = podcastsButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5)
        let trailing = podcastsButton.leadingAnchor.constraint(equalTo: musicButton.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, trailing])
        
        if podcastsButton.frame.height != 0 {
            podcastsButton.layer.cornerRadius = podcastsButton.frame.height/2
        }
    }
    
    private func fetchData() {
        var featurePlaylist: FeaturedPlaylist?
        var newReleasedAlbums: NewReleases?
        
        let dispatchGroup = DispatchGroup()
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
        
        dispatchGroup.notify(queue: .main) {
            guard let featPlaylists = featurePlaylist?.playlists.items, let newAlbums = newReleasedAlbums?.albums.items else {
                return
            }
            self.configureSectionsData(loadedPlaylists: featPlaylists, loadedAlbums: newAlbums)
        }
    }
    
    private func configureSectionsData(loadedPlaylists: [Playlist], loadedAlbums: [Album]) {
        self.playlists = loadedPlaylists
        self.albums = loadedAlbums
        
        sections.append(.featuredPlaylists(featuredPlaylists: loadedPlaylists))
        sections.append(.newReleases(newReleasedAlbums: loadedAlbums))
        
        collectionView.reloadData()
        
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        var buttons = [allButton, musicButton, podcastsButton]
        
        for button in buttons {
            button.backgroundColor = .filterBackground
            button.setTitleColor(.label, for: .normal)
        }
        
        sender.backgroundColor = UIColor.spotifyGreen
        sender.setTitleColor(.black, for: .normal)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        
        switch type {
        case .featuredPlaylists(let featPlaylists): return featPlaylists.count
        case .newReleases(let newAlbums): return newAlbums.count
        case .popularArtists: return 10
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .featuredPlaylists(let playlists):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylistCollectionViewCell
            cell.setContent(title: playlists[indexPath.row].name)
            return cell
        case .newReleases(let albums):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as! AlbumCollectionViewCell
            cell.setContent(title: albums[indexPath.row].name, artist: albums[indexPath.row].artists[0].name)
            return cell
        case .popularArtists:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularArtistCollectionViewCell.identifier, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as? UICollectionReusableView as? CollectionHeaderReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        var headerTitle: String
        
        switch sections[section] {
        case .featuredPlaylists: headerTitle = "Featured Playlists"
        case .newReleases: headerTitle = "New Releases"
        case .popularArtists: headerTitle = HomeSectionType.popularArtists.title
        }
        
        header.configureHeaderTitle(title: headerTitle)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var test = [ArtistViewController()]
        test[indexPath.row].modalPresentationStyle = .popover
        present(test[indexPath.row], animated: true)
    }
}
