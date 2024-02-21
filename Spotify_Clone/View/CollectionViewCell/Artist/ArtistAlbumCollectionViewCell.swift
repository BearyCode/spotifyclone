//
//  ArtistAlbumCollectionViewCell.swift
//  Spotify_Clone
//
//  Created by BearyCode on 19.02.24.
//

import UIKit

class ArtistAlbumCollectionViewCell: UICollectionViewCell {
    static let identifier = "ArtistAlbumCollectionViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.square")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Album"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeYearLabel: UILabel = {
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
        setupCoverImageView()
        setupAlbumNameLabel()
        setupTypeYearLabel()
    }
    
    private func setupCoverImageView() {
        addSubview(coverImageView)
        
        let top = coverImageView.topAnchor.constraint(equalTo: topAnchor)
        let trailing = coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        let bottom = coverImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
        let leading = coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func setupAlbumNameLabel() {
        addSubview(albumNameLabel)
        
        let top = albumNameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 5)
        let trailing = albumNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        let leading = albumNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    private func setupTypeYearLabel() {
        contentView.addSubview(typeYearLabel)
        
        let top = typeYearLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor)
        let trailing = typeYearLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = typeYearLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = typeYearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    public func setContent(title: String, typeYear: String, coverImageURL: String?) {
        albumNameLabel.text = title
        typeYearLabel.text = typeYear
        
        if let coverImageURL = coverImageURL {
            let url = URL(string: coverImageURL)
            coverImageView.sd_setImage(with: url)
        }
    }
}
