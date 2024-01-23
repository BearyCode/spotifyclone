//
//  PlaylistViewController.swift
//  Spotify_Clone
//
//  Created by BearyCode on 22.01.24.
//

import UIKit

class PlaylistViewController: UIViewController {
    private let playlist: Playlist
    private var tracks = [Track]()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SongListTableViewCell.self, forCellReuseIdentifier: SongListTableViewCell.identifier)
        return tableView
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.square")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Playlist"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Owner"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeYearLabel: UILabel = {
        let label = UILabel()
        label.text = "Album • 2024"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeButton: UIButton = {
        let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let menuButton: UIButton = {
        let image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playButton: UIButton = {
        let image = UIImage(systemName: "arrowtriangle.forward.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.spotifyGreen, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spotifyBackground
        setupCoverImageView()
        setupContainerView()
        setupAlbumTitleLabel()
        setupArtistLabel()
        setupTypeYearLabel()
        setupTableView()
        setContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLikeButton()
        setupMenuButton()
        setupPlayButton()
    }
    
    private func setupCoverImageView() {
        view.addSubview(coverImageView)
        
        let height = coverImageView.heightAnchor.constraint(equalToConstant: view.frame.height/3)
        let top = coverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let trailing = coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let leading = coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([height, top, trailing, leading])
    }
    
    private func setupContainerView() {
        view.addSubview(containerView)
        
        let height = containerView.heightAnchor.constraint(equalToConstant: view.frame.height/6)
        let top = containerView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor)
        let trailing = containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let leading = containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        
        NSLayoutConstraint.activate([height, top, trailing, leading])
        
        containerView.addSubview(albumTitleLabel)
        containerView.addSubview(artistLabel)
        containerView.addSubview(typeYearLabel)
        containerView.addSubview(likeButton)
        containerView.addSubview(menuButton)
        containerView.addSubview(playButton)
    }
    
    private func setupAlbumTitleLabel() {
        let top = albumTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor)
        let trailing = albumTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let leading = albumTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    private func setupArtistLabel() {
        let top = artistLabel.topAnchor.constraint(equalTo: albumTitleLabel.bottomAnchor, constant: 10)
        let trailing = artistLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let leading = artistLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    private func setupTypeYearLabel() {
        let top = typeYearLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10)
        let trailing = typeYearLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let leading = typeYearLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    private func setupLikeButton() {
        let height = likeButton.heightAnchor.constraint(equalToConstant: containerView.frame.height/5)
        let width = likeButton.widthAnchor.constraint(equalToConstant: containerView.frame.height/5)
        let top = likeButton.topAnchor.constraint(equalTo: typeYearLabel.bottomAnchor, constant: 10)
        let bottom = likeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        let leading = likeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([height, width, top, bottom, leading])
    }
    
    private func setupMenuButton() {
        let height = menuButton.heightAnchor.constraint(equalToConstant: containerView.frame.height/6)
        let width = menuButton.widthAnchor.constraint(equalToConstant: containerView.frame.height/6)
        let top = menuButton.topAnchor.constraint(equalTo: typeYearLabel.bottomAnchor, constant: 10)
        let bottom = menuButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        let leading = menuButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([height, width, top, leading])
    }
    
    private func setupPlayButton() {
        let height = playButton.heightAnchor.constraint(equalToConstant: (containerView.frame.height/2)-10)
        let width = playButton.widthAnchor.constraint(equalToConstant: (containerView.frame.height/2)-10)
        let trailing = playButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottom = playButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        
        NSLayoutConstraint.activate([height, width, trailing, bottom])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let top = tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func getAllTracks() {
        NetworkManager.shared.getPlaylistTracks(playlist: playlist) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let requestedPlaylist):
                    self.tracks = requestedPlaylist.tracks.items.compactMap({$0.track})
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setContent() {
        artistLabel.text = playlist.owner.display_name
        albumTitleLabel.text = playlist.name
        
        
        if let coverImageURL = playlist.images.first?.url {
            let url = URL(string: coverImageURL)
            coverImageView.sd_setImage(with: url)
        }
        
        getAllTracks()
    }
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongListTableViewCell.identifier, for: indexPath) as! SongListTableViewCell
        cell.selectionStyle = .none
        cell.setContent(title: tracks[indexPath.row].name, artist: tracks[indexPath.row].artists.first?.name)
        return cell
    }
    
    
}
