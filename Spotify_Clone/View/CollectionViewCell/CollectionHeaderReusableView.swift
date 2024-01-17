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
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubview(label)
        label.frame = CGRect(x: 10, y: 10, width: frame.size.width-30, height: frame.size.height)
    }
    
    func configureHeaderTitle(title: String) {
        label.text = title
    }
}
