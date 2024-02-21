//
//  AlbumTrackCollectionViewCell.swift
//  Spotify_Clone
//
//  Created by BearyCode on 13.02.24.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
    
    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.spotifyGreen, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Song Title"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        setupTitleLabel()
        setupArtistLabel()
        setupMenuButton()
        setupLikeImageView()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        let top = titleLabel.topAnchor.constraint(equalTo: topAnchor)
        let trailing = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        let leading = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    private func setupArtistLabel() {
        addSubview(artistLabel)
        
        let top = artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -10)
        let trailing = artistLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = artistLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = artistLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func setupMenuButton() {
        addSubview(menuButton)
        
        let centerY = menuButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        let trailing = menuButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([centerY, trailing])
    }
    
    private func setupLikeImageView() {
        addSubview(likeImageView)
        
        let centerY = likeImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let trailing = likeImageView.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -20)
        
        NSLayoutConstraint.activate([centerY, trailing])
    }
    
    public func setContent(title: String, artist: String?) {
        titleLabel.text = title
        artistLabel.text = artist
    }
}
