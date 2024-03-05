//
//  AlbumTrackCollectionViewCell.swift
//  Spotify_Clone
//
//  Created by BearyCode on 13.02.24.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
    
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
    
    public func setContent(title: String, artist: String?) {
        titleLabel.text = title
        artistLabel.text = artist
    }
}
