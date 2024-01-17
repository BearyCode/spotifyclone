//
//  PopularArtistCollectionViewCell.swift
//  SpotifyClone
//
//  Created by BearyCode on 18.11.23.
//

import UIKit

class PopularArtistCollectionViewCell: UICollectionViewCell {
    static let identifier = "PopularArtistCollectionViewCell"
    
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
        label.text = "Artist"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        setupContainerView()
        setupImageView()
        setupLabel()
    }
    
    private func setupContainerView() {
        let x = containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        let width = containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40)
        let height = containerView.heightAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40)
        let top = containerView.topAnchor.constraint(equalTo: contentView.topAnchor)
        
        NSLayoutConstraint.activate([x, width, height, top])
        
        containerView.layer.cornerRadius = contentView.frame.width/2.5
        containerView.addSubview(artistImageView)
    }
    
    private func setupImageView() {
        let top = artistImageView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let trailing = artistImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottom = artistImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        let leading = artistImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    private func setupLabel() {
        contentView.addSubview(artistNameLabel)
        
        let top = artistNameLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor)
        let trailing = artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottom = artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let leading = artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    func setContent() {
    }
}
