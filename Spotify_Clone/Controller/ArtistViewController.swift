//
//  ArtistViewController.swift
//  SpotifyClone
//
//  Created by BearyCode on 10.01.24.
//

import UIKit

class ArtistViewController: UIViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
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
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .spotifyGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let artitsLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "1,902,458 Followers"
        label.textColor = .systemGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spotifyBackground
        setupArtistImageView()
        setupArtistLabel()
        setupContainerView()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFollowButton()
        setupFollowersLabel()
        setupPlayButton()
    }
    
    private func setupArtistImageView() {
        view.addSubview(artistImageView)
        
        let top = artistImageView.topAnchor.constraint(equalTo: view.topAnchor)
        let trailing = artistImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = artistImageView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/3)
        let leading = artistImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func setupArtistLabel() {
        artistImageView.addSubview(artitsLabel)
        
        let bottom = artitsLabel.bottomAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: -10)
        let leading = artitsLabel.leadingAnchor.constraint(equalTo: artistImageView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, leading])
    }
    
    private func setupContainerView() {
        view.addSubview(containerView)
        
        let height = containerView.heightAnchor.constraint(equalToConstant: view.frame.height/8)
        let top = containerView.topAnchor.constraint(equalTo: artistImageView.bottomAnchor)
        let trailing = containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let leading = containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([height, top, trailing, leading])
        
        containerView.addSubview(followersLabel)
        containerView.addSubview(followButton)
        containerView.addSubview(playButton)
    }
    
    private func setupFollowButton() {
        let height = followButton.heightAnchor.constraint(equalToConstant: containerView.frame.height/3)
        let top = followButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        let leading = followButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([height, top, leading])
        
        
        followButton.layer.cornerRadius = followButton.frame.height/2
    }
    
    private func setupFollowersLabel() {
        let top = followersLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        let bottom = followersLabel.bottomAnchor.constraint(equalTo: followButton.topAnchor, constant: -10)
        let leading = followersLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, bottom, leading])
    }
    
    private func setupPlayButton() {
        let height = playButton.heightAnchor.constraint(equalToConstant: (containerView.frame.height/2)+10)
        let width = playButton.widthAnchor.constraint(equalToConstant: (containerView.frame.height/2)+10)
        let trailing = playButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        let bottom = playButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        
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
}

extension ArtistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongListTableViewCell.identifier, for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    
}
