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
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "123.456.789 Followers"
        label.textColor = .systemGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
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
        setupArtistImageView()
        setupArtistLabel()
        setupFollowersLabel()
        setupFollowButton()
    }
    
    private func setupArtistImageView() {
        addSubview(artistImageView)
        
        let height = artistImageView.heightAnchor.constraint(equalToConstant: (frame.height/3)*2)
        let top = artistImageView.topAnchor.constraint(equalTo: topAnchor)
        let trailing = artistImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let leading = artistImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        
        NSLayoutConstraint.activate([height, top, trailing, leading])
    }
    
    private func setupArtistLabel() {
        artistImageView.addSubview(artistLabel)
        
        let bottom = artistLabel.bottomAnchor.constraint(equalTo: artistImageView.bottomAnchor)
        let leading = artistLabel.leadingAnchor.constraint(equalTo: artistImageView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([bottom, leading])
    }
    
    private func setupFollowButton() {
        addSubview(followButton)
        
        let top = followButton.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 10)
        let height = followButton.heightAnchor.constraint(equalToConstant: 33)
        let leading = followButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([height, top, leading])
    }
    
    private func setupFollowersLabel() {
        addSubview(followersLabel)
        
        let top = followersLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 10)
        let trailing = followersLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        let leading = followersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    private func followerNumberFormatter(_ followerNumber: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let formattedNumber = formatter.string(from: NSNumber(value: followerNumber)) {
            return formattedNumber
        }
        
        return ""
    }
    
    public func setContent(artistName: String, followers: Int, coverImageURL: String?) {
        artistLabel.text = artistName
        followersLabel.text = "\(followerNumberFormatter(followers)) followers"
        
        if let coverImageURL = coverImageURL {
            let url = URL(string: coverImageURL)
            artistImageView.sd_setImage(with: url)
        }
    }
}
