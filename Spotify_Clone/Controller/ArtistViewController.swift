//
//  ArtistViewController.swift
//  SpotifyClone
//
//  Created by BearyCode on 10.01.24.
//

import UIKit

enum ArtistSectionType {
    case artistHeader
    case popularTracks(popularTracks: [Track])
    case albums(albums: [Album])
    case relatedArtists(relatedArtists: [Artist])
}

class ArtistViewController: UIViewController {
    
    let artist: Artist
    var popularTracks = [Track]()
    var albums = [Album]()
    var relatedArtists = [Artist]()
    
    private var sections = [ArtistSectionType]()
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return ArtistViewController.createSectionsLayout(section: sectionIndex)
    })
    
    init(artist: Artist) {
        self.artist = artist
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
        navigationController?.navigationBar.barTintColor = .spotifyBackground
    }
    
    private func setupNavigationBar() {
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .spotifyBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    private static func createSectionsLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
            return section
            
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400)), subitem: item, count: 1)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitem: horizontalGroup, count: 5)
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
            
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48), heightDimension: .absolute(200)), subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
            
        case 3:
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
        collectionView.register(ArtistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ArtistHeaderCollectionReusableView.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        collectionView.register(ArtistPopularTrackCollectionViewCell.self, forCellWithReuseIdentifier: ArtistPopularTrackCollectionViewCell.identifier)
        collectionView.register(ArtistAlbumCollectionViewCell.self, forCellWithReuseIdentifier: ArtistAlbumCollectionViewCell.identifier)
        collectionView.register(ArtistRecommandedCollectionViewCell.self, forCellWithReuseIdentifier: ArtistRecommandedCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        let top = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func fetchData() {
        var requestedPopularTracks = [Track]()
        var requestedArtistAlbums = [Album]()
        var requestedRelatedArtists = [Artist]()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        NetworkManager.shared.getArtistTopTracks(artist: artist) { result in
            defer {
                dispatchGroup.leave()
            }
            
            switch result {
            case.success(let reqestedTracks):
                requestedPopularTracks = reqestedTracks
            case .failure(let error):
                print(error)
            }
            
        }
        
        NetworkManager.shared.getArtistAlbums(artist: artist) { result in
            defer {
                dispatchGroup.leave()
            }
            
            switch result {
            case .success(let requestedAlbums):
                requestedArtistAlbums = requestedAlbums
            case .failure(let error):
                print(error)
            }
        }
        
        NetworkManager.shared.getRelatedArtists(artist: artist) { result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let requestedArtists):
                requestedRelatedArtists = requestedArtists
            case .failure(let error):
                print(error)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.configureSectionsData(loadedTracks: requestedPopularTracks, loadedAlbums: requestedArtistAlbums, loadedArtists: requestedRelatedArtists)
        }
    }
    
    private func configureSectionsData(loadedTracks: [Track], loadedAlbums: [Album], loadedArtists: [Artist]) {
        popularTracks = loadedTracks
        albums = loadedAlbums
        relatedArtists = loadedArtists
        
        sections.append(.artistHeader)
        sections.append(.popularTracks(popularTracks: loadedTracks))
        sections.append(.albums(albums: loadedAlbums))
        sections.append(.relatedArtists(relatedArtists: loadedArtists))
        
        collectionView.reloadData()
    }
    
    private func formatTypeYear(type: String, date: String) -> String {
        var formattedYear = 0
        
        let correctedType: String = {
            
            guard let firstChar = type.first else {
                return ""
            }
            
            var endString = type
            endString.removeFirst()
            
            return firstChar.uppercased() + endString
        }()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        
        if let date = formatter.date(from: date) {
            let calender = Calendar.current
            formattedYear = calender.component(.year, from: date)
        }
        
        if formattedYear != 0 {
            return "\(formattedYear) • \(correctedType)"
        }
        
        return "\(correctedType)"
    }
}

extension ArtistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let selectedSection = sections[section]
        
        switch selectedSection {
        case .popularTracks(let tracks):
            return tracks.count
        case .albums(let albums):
            return albums.count
        case .relatedArtists(let artists):
            return artists.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .popularTracks(let tracks):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistPopularTrackCollectionViewCell.identifier, for: indexPath) as! ArtistPopularTrackCollectionViewCell
            cell.setContent(number: indexPath.row+1, title: tracks[indexPath.row].name, coverImageURL: tracks[indexPath.row].album?.images.first?.url)
            return cell
        case .albums(let albums):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistAlbumCollectionViewCell.identifier, for: indexPath) as! ArtistAlbumCollectionViewCell
            cell.setContent(title: albums[indexPath.row].name, typeYear: formatTypeYear(type: albums[indexPath.row].album_type, date: albums[indexPath.row].release_date), coverImageURL: albums[indexPath.row].images.first?.url)
            return cell
        case .relatedArtists(let artists):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistRecommandedCollectionViewCell.identifier, for: indexPath) as! ArtistRecommandedCollectionViewCell
            cell.setContent(title: artists[indexPath.row].name, coverImageURL: artists[indexPath.row].images?.first?.url)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as UICollectionReusableView as? CollectionHeaderReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let section = sections[indexPath.section]
        
        switch section {
        case .artistHeader:
            guard let artistHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ArtistHeaderCollectionReusableView.identifier, for: indexPath) as? ArtistHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            artistHeader.setContent(artistName: artist.name, followers: 123456789, coverImageURL: artist.images?.first?.url)
            return artistHeader
            
        case .popularTracks:
            header.setHeaderTitle(title: "Popular")
            return header
            
        case .albums:
            header.setHeaderTitle(title: "Releases")
            return header
            
        case .relatedArtists:
            header.setHeaderTitle(title: "Fans also like")
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        
        switch section {
        case .popularTracks(popularTracks: let tracks):
            // let vc = PlaylistViewController(playlist: playlists[indexPath.row])
            // navigationController?.pushViewController(vc, animated: true)
            print("Play track")
        case .albums(albums: let albums):
            let vc = AlbumViewController(album: albums[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        case .relatedArtists(relatedArtists: let artists):
            let vc = ArtistViewController(artist: artists[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
