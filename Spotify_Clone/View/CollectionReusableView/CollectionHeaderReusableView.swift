//
//  CollectionHeaderReusableView.swift
//  SpotifyClone
//
//  Created by BearyCode on 18.11.23.
//

import UIKit

class CollectionHeaderReusableView: UICollectionReusableView {
    static let identifier = "CollectionHeaderReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 1
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
        backgroundColor = .clear
        setupLabel()
    }
    
    private func setupLabel() {
        addSubview(label)
        
        let top = label.topAnchor.constraint(equalTo: topAnchor)
        let trailing = label.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = label.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, bottom, leading])
    }
    
    func setHeaderTitle(title: String) {
        label.text = title
    }
}
