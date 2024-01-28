//
//  LibraryArtistTableViewCell.swift
//  SpotifyClone
//
//  Created by BearyCode on 21.12.23.
//

import UIKit
import SDWebImage

class LibraryArtistTableViewCell: UITableViewCell {
    static let identifier = "LibraryArtistTableViewCell"
        
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist Album"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist"
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
        contentView.addSubview(artistImageView)
        
        let width = artistImageView.widthAnchor.constraint(equalTo: artistImageView.heightAnchor)
        let top = artistImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        let bottom = artistImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        let leading = artistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([width, top, bottom, leading])
        
        artistImageView.layer.cornerRadius = (contentView.frame.height-10)/2
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        let top = containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        let trailing = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottom = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        let leading = containerView.leadingAnchor.constraint(equalTo: artistImageView.trailingAnchor, constant: 10)

        NSLayoutConstraint.activate([top, trailing, bottom, leading])
        
        containerView.addSubview(artistNameLabel)
        containerView.addSubview(typeLabel)
    }

    private func setupArtistAlbumLabel() {
        let centerY = artistNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10)
        let trailing = artistNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let leading = artistNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([centerY, trailing, leading])
    }
    
    private func setupTypeLabel() {
        let centerY = typeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 10)
        let trailing = typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottom = typeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        let leading = typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([centerY, trailing, bottom, leading])
    }
    
    public func setContent(imageURL: String?, artistName: String?) {
        artistNameLabel.text = artistName ?? ""
        
        if let imageURL = imageURL {
            let url = URL(string: imageURL)
            artistImageView.sd_setImage(with: url)
        }
    }
}
