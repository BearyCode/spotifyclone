//
//  SearchResultArtistTableViewCell.swift
//  Spotify_Clone
//
//  Created by BearyCode on 21.02.24.
//

import UIKit

class SearchResultSongTableViewCell: UITableViewCell {
    static let identifier = "SearchResultArtistTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let songTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Song"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Song • Artist"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        setupImageView()
        setupContainerView()
        setupSongTitleLabel()
        setupTypeLabel()
    }

    private func setupImageView() {
        contentView.addSubview(albumImageView)
        
        let width = albumImageView.widthAnchor.constraint(equalTo: albumImageView.heightAnchor)
        let top = albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        let bottom = albumImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        let leading = albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([width, top, bottom, leading])
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        let top = containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        let trailing = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottom = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        let leading = containerView.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10)

        NSLayoutConstraint.activate([top, trailing, bottom, leading])
        
        containerView.addSubview(songTitleLabel)
        containerView.addSubview(typeLabel)
    }

    private func setupSongTitleLabel() {
        let centerY = songTitleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10)
        let trailing = songTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let leading = songTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([centerY, trailing, leading])
    }
    
    private func setupTypeLabel() {
        let centerY = typeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 10)
        let trailing = typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottom = typeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        let leading = typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([centerY, trailing, bottom, leading])
    }
    
    public func setContent(imageURL: String?, songTitle: String, artistName: String?) {
        songTitleLabel.text = songTitle
        typeLabel.text = "Song • \(artistName ?? "")"
        if let imageURL = imageURL {
            let url = URL(string: imageURL)
            albumImageView.sd_setImage(with: url)
        }
    }
}
