//
//  ArtistRecommandedCollectionViewCell.swift
//  Spotify_Clone
//
//  Created by BearyCode on 19.02.24.
//

import UIKit

class ArtistRecommandedCollectionViewCell: UICollectionViewCell {
    static let identifier = "ArtistRecommandedCollectionViewCell"
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.square")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
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
        setupArtistImageView()
        setupArtistNameLabel()
    }
    
    private func setupArtistImageView() {
        addSubview(artistImageView)
        
        let height = artistImageView.heightAnchor.constraint(equalToConstant: frame.width-20)
        let width = artistImageView.widthAnchor.constraint(equalToConstant: frame.width-20)
        let centerX = artistImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let top = artistImageView.topAnchor.constraint(equalTo: topAnchor)
        let trailing = artistImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        let bottom = artistImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        let leading = artistImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([centerX, top, height, width])
        
        artistImageView.layer.cornerRadius = (contentView.frame.width-20)/2
    }
    
    private func setupArtistNameLabel() {
        addSubview(artistNameLabel)
        
        let top = artistNameLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 5)
        let trailing = artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        let leading = artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    public func setContent(title: String, coverImageURL: String?) {
        artistNameLabel.text = title
        
        if let coverImageURL = coverImageURL {
            let url = URL(string: coverImageURL)
            artistImageView.sd_setImage(with: url)
        }
    }
}
