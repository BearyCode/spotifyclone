//
//  RecommandedTracksCollectionViewCell.swift
//  SpotifyClone
//
//  Created by BearyCode on 18.11.23.
//

import UIKit
import SDWebImage

class RecommandedTracksCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommandedTracksCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Song Title"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let menuButton: UIButton = {
        let image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        setupCoverImageView()
        setupContainerView()
        setupTitleLabel()
        setupArtistLabel()
        setupMenuButton()
    }
    
    private func setupCoverImageView() {
        addSubview(coverImageView)
        
        let height = coverImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height-10)
        let width = coverImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height-10)
        let top = coverImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        let bottom = coverImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        let leading = coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([height, width, top, bottom, leading])
    }
    
    private func setupContainerView() {
        addSubview(containerView)
        
        let top = containerView.topAnchor.constraint(equalTo: topAnchor)
        let trailing = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottom = containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = containerView.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, bottom, trailing, leading])
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(artistLabel)
        containerView.addSubview(menuButton)
    }
    
    private func setupTitleLabel() {
        let centerY = titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 10)
        let leading = titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([centerY, leading])
    }
    
    private func setupArtistLabel() {
        let top = artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        let bottom = artistLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        let leading = artistLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, bottom, leading])
    }
    
    private func setupMenuButton() {
        let centerY = menuButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        let trailing = menuButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([centerY, trailing])
    }
    
    public func setContent(title: String, artist: String, coverImageURL: String?) {
        titleLabel.text = title
        artistLabel.text = artist
        
        if let coverImageURL = coverImageURL {
            let url = URL(string: coverImageURL)
            coverImageView.sd_setImage(with: url)
        }
    }
}
