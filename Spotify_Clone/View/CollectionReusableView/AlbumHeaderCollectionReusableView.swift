//
//  AlbumHeaderCollectionReusableView.swift
//  Spotify_Clone
//
//  Created by BearyCode on 14.02.24.
//

import UIKit

class AlbumHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "AlbumHeaderCollectionReusableView"
    
    public weak var delegate: AlbumHeaderActionsDelegate?
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Album Titel"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeYearLabel: UILabel = {
        let label = UILabel()
        label.text = "Album • 2024"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
//        checkmark.circle.fill
        let image = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveAlbum(_:)), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(playAllTracks(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCoverImageView()
        setupAlbumTitleLabel()
        setupArtistNameLabel()
        setupTypeYearLabel()
        setupAddButton()
        setupPlayButton()
    }
    
    private func setupCoverImageView() {
        addSubview(coverImageView)
        
        let height = coverImageView.heightAnchor.constraint(equalToConstant: frame.width/1.5)
        let width = coverImageView.widthAnchor.constraint(equalToConstant: frame.width/1.5)
        
        let centerX = coverImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let top = coverImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        
        NSLayoutConstraint.activate([height, width, centerX, top])
    }
    
    private func setupAlbumTitleLabel() {
        addSubview(albumTitleLabel)
        
        let top = albumTitleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 10)
        let leading = albumTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, leading])
    }
    
    private func setupArtistNameLabel() {
        addSubview(artistNameLabel)
        
        let top = artistNameLabel.topAnchor.constraint(equalTo: albumTitleLabel.bottomAnchor, constant: 5)
        let leading = artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, leading])
    }
    
    private func setupTypeYearLabel() {
        addSubview(typeYearLabel)
        
        let top = typeYearLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor,constant: 5)
        let leading = typeYearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, leading])
    }
    
    private func setupAddButton() {
        addSubview(addButton)
        
        let height = addButton.heightAnchor.constraint(equalToConstant: 22)
        let width = addButton.widthAnchor.constraint(equalToConstant: 22)
        let top = addButton.topAnchor.constraint(equalTo: typeYearLabel.bottomAnchor, constant: 5)
        let leading = addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([height, width, top, leading])
    }
    
    private func setupPlayButton() {
        addSubview(playButton)
        
        let height = playButton.heightAnchor.constraint(equalToConstant: 44)
        let width = playButton.widthAnchor.constraint(equalToConstant: 44)
        let top = playButton.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 5)
        let trailing = playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([height, width, top, trailing])
    }
    
    public func setContent(albumTitle: String, artistName: String, typeYear: String, coverImageURL: String?) {
        albumTitleLabel.text = albumTitle
        artistNameLabel.text = artistName
        typeYearLabel.text = typeYear
        
        if let coverImageURL = coverImageURL {
            let url = URL(string: coverImageURL)
            coverImageView.sd_setImage(with: url)
        }
    }
    
    @objc private func playAllTracks(_ sender: UIButton) {
        delegate?.playAllTracks(sender)
    }
    
    @objc private func saveAlbum(_ sender: UIButton) {
        delegate?.saveAlbum(sender)
    }
}
