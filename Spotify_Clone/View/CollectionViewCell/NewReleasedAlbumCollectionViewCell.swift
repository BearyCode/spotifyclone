//
//  NewReleasedAlbumCollectionViewCell.swift
//  SpotifyClone
//
//  Created by BearyCode on 19.11.23.
//

import UIKit
import SDWebImage

class NewReleasedAlbumCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleasedAlbumCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.square")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Content"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Album • Artist"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupImageView()
        setupContainerView()
        setupAlbumNameLabel()
        setupArtistLabel()
    }
    
    private func setupImageView() {
        contentView.addSubview(coverImageView)
        
        let top = coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        let trailing = coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        let bottom = coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        let leading = coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        let top = containerView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor)
        let trailing = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        let bottom = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let leading = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func setupAlbumNameLabel() {
        contentView.addSubview(albumNameLabel)
        
        let top = albumNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor)
        let trailing = albumNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let leading = albumNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    private func setupArtistLabel() {
        contentView.addSubview(artistLabel)
        
        let top = artistLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor)
        let trailing = artistLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottom = artistLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        let leading = artistLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    public func setContent(title: String, artist: String, coverImageURL: String?) {
        albumNameLabel.text = title
        artistLabel.text = "Album • \(artist)"
        
        if let coverImageURL = coverImageURL {
            let url = URL(string: coverImageURL)
            coverImageView.sd_setImage(with: url)
        }
    }
}
