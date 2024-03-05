//
//  HeaderView.swift
//  SpotifyClone
//
//  Created by BearyCode on 03.01.24.
//

import UIKit

class MainViewControllerHeaderView: UIView, MainHeaderDelegate {
    
    public weak var delegate: MainHeaderDelegate?
    
    private let colors = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemBrown, UIColor.systemGray, UIColor.green]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let profileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBrown
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(openProfile(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
        setupProfileButton()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(profileButton)
        self.addSubview(titleLabel)
    }
    
    private func setupProfileButton() {
        let top = profileButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        let leading = profileButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        
        setupTitleLabel()
        
        let height = profileButton.heightAnchor.constraint(equalToConstant: 33)
        let width = profileButton.widthAnchor.constraint(equalToConstant: 33)
        
        NSLayoutConstraint.activate([width, height, top, leading])
        
        profileButton.layer.cornerRadius = 33/2
    }
    
    private func setupTitleLabel() {
        
        let trailing: NSLayoutConstraint
        
        if titleLabel.text == "" {
            trailing = titleLabel.trailingAnchor.constraint(equalTo: profileButton.trailingAnchor, constant: 10)
        } else {
            trailing = titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        }
        
        let top = titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        let leading = titleLabel.leadingAnchor.constraint(equalTo: profileButton.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, trailing, leading])
    }
    
    public func setTitle(title: String) {
        if title == "" {
            titleLabel.removeFromSuperview()
        } else {
            titleLabel.text = title
        }
    }
    
    public func setProfilePicture(urlString: String?, username: String?) {
        if let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) {
            profileButton.sd_setImage(with: url, for: .normal)
        } else if let username = username, let firstChar = username.first {
            profileButton.setTitle("\(firstChar)", for: .normal)
        }
        
    }
    
    @objc func openProfile(_ sender: UIButton) {
        delegate?.openProfile(sender)
    }
}
