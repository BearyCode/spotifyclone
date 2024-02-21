//
//  LibraryPlaylistTableViewCell.swift
//  Spotify_Clone
//
//  Created by BearyCode on 27.01.24.
//

import UIKit
import SDWebImage

class LibraryPlaylistTableViewCell: UITableViewCell {
    static let identifier = "LibraryPlaylistTableViewCell"
        
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Album"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Playlist • 00 Songs"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        setupImageView()
        setupContainerView()
        setupArtistAlbumLabel()
        setupTypeLabel()
    }
    
    private func setupImageView() {
        contentView.addSubview(playlistImageView)
        
        let width = playlistImageView.widthAnchor.constraint(equalTo: playlistImageView.heightAnchor)
        let top = playlistImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        let bottom = playlistImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        let leading = playlistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([width, top, bottom, leading])
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        let top = containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        let trailing = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottom = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        let leading = containerView.leadingAnchor.constraint(equalTo: playlistImageView.trailingAnchor, constant: 10)

        NSLayoutConstraint.activate([top, trailing, bottom, leading])
        
        containerView.addSubview(playlistNameLabel)
        containerView.addSubview(typeLabel)
    }

    private func setupArtistAlbumLabel() {
        let centerY = playlistNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10)
        let trailing = playlistNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let leading = playlistNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([centerY, trailing, leading])
    }
    
    private func setupTypeLabel() {
        let centerY = typeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 10)
        let trailing = typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottom = typeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        let leading = typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([centerY, trailing, bottom, leading])
    }
    
    public func setContent(imageURL: String?, playlistName: String, numberOfSongs: Int) {
        playlistNameLabel.text = playlistName
        typeLabel.text = "Playlist • \(numberOfSongs) Songs"
        if let imageURL = imageURL {
            let url = URL(string: imageURL)
            playlistImageView.sd_setImage(with: url)
        }
    }
}
