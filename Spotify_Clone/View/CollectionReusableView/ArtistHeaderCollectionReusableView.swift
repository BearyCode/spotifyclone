//
//  ArtistHeaderCollectionReusableView.swift
//  Spotify_Clone
//
//  Created by BearyCode on 17.02.24.
//

import UIKit

class ArtistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        setupArtistImageView()
        setupArtistLabel()
    }
    
    private func setupArtistImageView() {
        addSubview(artistImageView)
    
        let top = artistImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let trailing = artistImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = artistImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = artistImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func setupArtistLabel() {
        artistImageView.addSubview(artistLabel)
        
        let trailing = artistLabel.trailingAnchor.constraint(equalTo: artistImageView.trailingAnchor, constant: -10)
        let bottom = artistLabel.bottomAnchor.constraint(equalTo: artistImageView.bottomAnchor)
        let leading = artistLabel.leadingAnchor.constraint(equalTo: artistImageView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([trailing, bottom, leading])
    }
    
    public func setContent(artistName: String, followers: Int, coverImageURL: String?) {
        artistLabel.text = artistName
        
        if let coverImageURL = coverImageURL {
            let url = URL(string: coverImageURL)
            artistImageView.sd_setImage(with: url)
        }
    }
}
