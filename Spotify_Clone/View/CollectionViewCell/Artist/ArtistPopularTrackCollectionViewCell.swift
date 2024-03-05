//
//  ArtistPopularTrackCollectionViewCell.swift
//  Spotify_Clone
//
//  Created by BearyCode on 19.02.24.
//

import UIKit

class ArtistPopularTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "ArtistPopularTrackCollectionViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        setupNumberLabel()
        setupCoverImageView()
        setupTitleLabel()
    }
    
    private func setupCoverImageView() {
        addSubview(coverImageView)
        
        let height = coverImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height-10)
        let width = coverImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height-10)
        let centerY = coverImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let leading = coverImageView.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([height, width, centerY, leading])
    }
    
    private func setupNumberLabel() {
        addSubview(numberLabel)
        
        let centerY = numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        let leading = numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([centerY, leading])
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        let centerY = titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        let trailing = titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([centerY, trailing])
    }
    
    public func setContent(number: Int, title: String, coverImageURL: String?) {
        numberLabel.text = "\(number)"
        titleLabel.text = title
        
        if let coverImageURL = coverImageURL {
            let url = URL(string: coverImageURL)
            coverImageView.sd_setImage(with: url)
        }
    }
}
