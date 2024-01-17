//
//  LibraryTableViewCell.swift
//  SpotifyClone
//
//  Created by BearyCode on 21.12.23.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {
    static let identifier = "LibraryTableViewCell"
    
    public var isAlbum: Bool?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let artistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let artistAlbumLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist Album"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Album • Artist"
        label.font = .systemFont(ofSize: 15, weight: .regular)
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
        contentView.addSubview(artistCoverImageView)
        
        if let isAlbum = isAlbum {
            artistCoverImageView.image = isAlbum ? UIImage(systemName: "person.crop.square") : UIImage(systemName: "person.crop.circle.fill")
            artistCoverImageView.layer.cornerRadius = isAlbum ? 0 : (contentView.frame.height-10)/2
        }
        
        let width = artistCoverImageView.widthAnchor.constraint(equalTo: artistCoverImageView.heightAnchor)
        let top = artistCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        let bottom = artistCoverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        let leading = artistCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([width, top, bottom, leading])
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        let top = containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        let trailing = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottom = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        let leading = containerView.leadingAnchor.constraint(equalTo: artistCoverImageView.trailingAnchor, constant: 10)

        NSLayoutConstraint.activate([top, trailing, bottom, leading])
        
        containerView.addSubview(artistAlbumLabel)
        containerView.addSubview(typeLabel)
    }

    private func setupArtistAlbumLabel() {
        
        if let isAlbum = isAlbum {
            artistAlbumLabel.text = isAlbum ? "Album" : "Artist"
        }
        
        let centerY = artistAlbumLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10)
        let trailing = artistAlbumLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let leading = artistAlbumLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([centerY, trailing, leading])
    }
    
    private func setupTypeLabel() {
        
        if let isAlbum = isAlbum {
            typeLabel.text = isAlbum ? "Album • Artist" : "Artist"
        }
        
        let centerY = typeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 10)
        let trailing = typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottom = typeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        let leading = typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([centerY, trailing, bottom, leading])
    }
}
