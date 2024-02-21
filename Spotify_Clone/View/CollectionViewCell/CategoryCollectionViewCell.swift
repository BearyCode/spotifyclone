//
//  CategoryCollectionViewCell.swift
//  Spotify_Clone
//
//  Created by BearyCode on 27.01.24.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private var colors: [UIColor] = [ .systemRed, .systemBlue, .systemPink, .systemOrange, .systemTeal, .systemGreen, .systemYellow, .systemPurple, .systemIndigo]
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let categoryNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Content"
        label.font = .systemFont(ofSize: 18, weight: .bold)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupIconImageView()
        setupCategoryNameLabel()
    }
    
    private func setupIconImageView() {
        addSubview(iconImageView)
        
        let width = iconImageView.widthAnchor.constraint(equalToConstant: frame.width/3)
        let top = iconImageView.topAnchor.constraint(equalTo: topAnchor)
        let trailing = iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        let bottom = iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        NSLayoutConstraint.activate([width, top, trailing, bottom])
    }
    
    private func setupCategoryNameLabel() {
        addSubview(categoryNameLabel)
        
        let top = categoryNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        let trailing = categoryNameLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor)
        let bottom = categoryNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = categoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    public func setContent(categoyName: String , iconURL: String?) {
        backgroundColor = colors.randomElement()
        
        categoryNameLabel.text = categoyName
        
        if let iconURL = iconURL {
            let url = URL(string: iconURL)
            iconImageView.sd_setImage(with: url)
        }
    }
}
