//
//  PlaylistCollectionViewCell.swift
//  SpotifyClone
//
//  Created by BearyCode on 17.01.24.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlaylistCollectionViewCell"
    
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
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Content"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
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
        setupPlaylistNameLabel()
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
    
    private func setupPlaylistNameLabel() {
        contentView.addSubview(playlistNameLabel)
        
        let top = playlistNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor)
        let trailing = playlistNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottom = playlistNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        let leading = playlistNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    public func setContent(title: String) {
        playlistNameLabel.text = title
    }
}
