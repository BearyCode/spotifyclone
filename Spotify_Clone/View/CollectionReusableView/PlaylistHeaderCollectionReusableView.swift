//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify_Clone
//
//  Created by BearyCode on 12.02.24.
//

import UIKit

class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    public weak var delegate: PlaylistHeaderActionsDelegate?
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "This is a description"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.text = "Owner"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "123.456.789 saves"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
//        checkmark.circle.fill
        let image = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(savePlaylist(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playButton: UIButton = {
        let image = UIImage(systemName: "arrowtriangle.forward.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(.spotifyGreen, renderingMode: .alwaysOriginal)
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
        setupDescriptionLabel()
        setupOwnerLabel()
        setupFollowersLabel()
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
    
    private func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        
        let top = descriptionLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 10)
        let leading = descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        let trailing = descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    private func setupOwnerLabel() {
        addSubview(ownerLabel)
        
        let top = ownerLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 5)
        let leading = ownerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        let trailing = ownerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    private func setupFollowersLabel() {
        addSubview(followersLabel)
        
        let top = followersLabel.topAnchor.constraint(equalTo: ownerLabel.bottomAnchor,constant: 5)
        let leading = followersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        let trailing = followersLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    private func setupAddButton() {
        addSubview(addButton)
        
        let height = addButton.heightAnchor.constraint(equalToConstant: 22)
        let width = addButton.widthAnchor.constraint(equalToConstant: 22)
        let top = addButton.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 5)
        let leading = addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([height, width, top, leading])
    }
    
    private func setupPlayButton() {
        addSubview(playButton)
        
        let height = playButton.heightAnchor.constraint(equalToConstant: 44)
        let width = playButton.widthAnchor.constraint(equalToConstant: 44)
        let top = playButton.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 5)
        let trailing = playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([height, width, top, trailing])
    }
    
    public func setContent(description: String, owner: String, followers: Int, coverImageURL: String?) {
        descriptionLabel.text = description
        ownerLabel.text = owner
        followersLabel.text = followers != 0 ? "\(Globals.shared.followerNumberFormatter(followerNumber: followers)) saves" : ""
        
        if let coverImageURL = coverImageURL {
            let url = URL(string: coverImageURL)
            coverImageView.sd_setImage(with: url)
        }
    }
    
    @objc private func playAllTracks(_ sender: UIButton) {
        delegate?.playAllTracks(sender)
    }
    
    @objc private func savePlaylist(_ sender: UIButton) {
        delegate?.savePlaylist(sender)
    }
}
