//
//  ProfileViewController.swift
//  Spotify_Clone
//
//  Created by BearyCode on 02.03.24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var currentUser: User?
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "Followers: 123456789"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBrown
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    init(currentUser: User? = nil) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spotifyBackground
        setupProfileImageView()
        setupUsernameLabel()
        setupFollowersLabel()
        setupLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .spotifyBackground
    }

    private func setupProfileImageView() {
        view.addSubview(profileImageView)
        
        let top = profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        let leading = profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        
        let height = profileImageView.heightAnchor.constraint(equalToConstant: 66)
        let width = profileImageView.widthAnchor.constraint(equalToConstant: 66)
        
        NSLayoutConstraint.activate([width, height, top, leading])
        
        profileImageView.layer.cornerRadius = 66/2
    }

    private func setupUsernameLabel() {
        view.addSubview(usernameLabel)
        
        usernameLabel.text = currentUser?.display_name
        let centerY = usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        let leading = usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([centerY, leading])
    }
    
    private func setupFollowersLabel() {
        view.addSubview(followersLabel)
        
        followersLabel.text = "Followers: \(Globals.shared.followerNumberFormatter(followerNumber: currentUser?.followers.total ?? 0))"
        let top = followersLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5)
        let leading = followersLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top, leading])
    }
    
    private func setupLogoutButton() {
        view.addSubview(logoutButton)
        
        let heigth = logoutButton.heightAnchor.constraint(equalToConstant: 40)
        let width = logoutButton.widthAnchor.constraint(equalToConstant: 100)
        let centerX = logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let bottom = logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        
        NSLayoutConstraint.activate([heigth, width, centerX,bottom])
    }
    
    @objc private func logoutButtonTapped(_ sender: UIButton) {
        NetworkManager.shared.logout { logout in
            if logout {
                DispatchQueue.main.async {
                    let navVC = UINavigationController(rootViewController: LoginViewController())
                    navVC.popToRootViewController(animated: false)
//                    print("logged out")
//                    navVC.navigationBar.prefersLargeTitles = true
//                    navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
//                    navVC.modalPresentationStyle = .fullScreen
//                    self.present(navVC, animated: true, completion: {
//                        self.navigationController?.popToRootViewController(animated: true)
//                    })
                }
            }
        }
    }
}
