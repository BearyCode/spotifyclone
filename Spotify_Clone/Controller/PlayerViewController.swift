//
//  PlayerViewController.swift
//  Spotify_Clone
//
//  Created by BearyCode on 22.02.24.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    private var track: Track?
    private var tracks: [Track]?
    private var coverURLString: String?
    private var index = 0
    
    private var player: AVPlayer?
    private var queue: AVQueuePlayer?
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.square")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let image = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let previousButton: UIButton = {
        let image = UIImage(systemName: "arrowtriangle.backward.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(goToPreviousTrack(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(playPauseTrack(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let image = UIImage(systemName: "arrowtriangle.forward.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(goToNextTrack(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let volumeSlider: UISlider = {
        let minImage = UIImage(systemName: "speaker.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let maxImage = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let slider = UISlider()
        slider.value = 0.5
        slider.tintColor = .white
        slider.minimumValueImage = minImage
        slider.maximumValueImage = maxImage
        slider.addTarget(self, action: #selector(setVolume(_:)), for: .touchUpInside)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    init(track: Track? = nil, tracks: [Track]? = nil, coverURLString: String?) {
        self.track = track
        self.tracks = tracks
        self.coverURLString = coverURLString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .spotifyBackground
        setupCoverImageView()
        setupTitleLabel()
        setupArtistLabel()
        setupAddButton()
        setupPlayPauseButton()
        setupPreviousButton()
        setupNextButton()
        setupVolumeSlider()
        setContent()
        startPlaying(track: track, tracks: tracks)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .spotifyBackground
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        index = 0
    }

    private func setupCoverImageView() {
        view.addSubview(coverImageView)
        
        let height = coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor)
        let top = coverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        let trailing = coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        let leading = coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        
        NSLayoutConstraint.activate([height, top, trailing, leading])
        
        coverImageView.layer.cornerRadius = 10
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        let top = titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 40)
        let trailing = titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        let leading = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        
        NSLayoutConstraint.activate([top, leading])
    }
    
    private func setupArtistLabel() {
        view.addSubview(artistLabel)
        
        let top = artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        let leading = artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        
        NSLayoutConstraint.activate([top, leading])
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        
        let height = addButton.heightAnchor.constraint(equalToConstant: 30)
        let width = addButton.widthAnchor.constraint(equalToConstant: 30)
        let top = addButton.topAnchor.constraint(equalTo: artistLabel.topAnchor, constant: -10)
        let trailing = addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        
        NSLayoutConstraint.activate([height, width, top, trailing])
    }
    
    private func setupPlayPauseButton() {
        view.addSubview(playPauseButton)
        
        let height = playPauseButton.heightAnchor.constraint(equalToConstant: 60)
        let width = playPauseButton.widthAnchor.constraint(equalToConstant: 60)
        let centerX = playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let top = playPauseButton.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10)
        
        NSLayoutConstraint.activate([height, width, centerX, top])
    }
    
    private func setupPreviousButton() {
        view.addSubview(previousButton)
        
        let height = previousButton.heightAnchor.constraint(equalToConstant: 25)
        let width = previousButton.widthAnchor.constraint(equalToConstant: 25)
        let centerY = previousButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor)
        let trailing = previousButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -20)
        
        NSLayoutConstraint.activate([height, width, centerY, trailing])
    }
    
    private func setupNextButton() {
        view.addSubview(nextButton)
        
        let height = nextButton.heightAnchor.constraint(equalToConstant: 25)
        let width = nextButton.widthAnchor.constraint(equalToConstant: 25)
        let centerY = nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor)
        let leading = nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 20)
        
        NSLayoutConstraint.activate([height, width, centerY, leading])
    }
    
    private func setupVolumeSlider() {
        view.addSubview(volumeSlider)
        
        let height = volumeSlider.heightAnchor.constraint(equalToConstant: 44)
        let top = volumeSlider.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 20)
        let trailing = volumeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        let leading = volumeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        
        NSLayoutConstraint.activate([height, top, trailing, leading])
    }

    private func setContent() {
        guard let track = track else {
            return
        }
        
        if let url = coverURLString {
            coverImageView.sd_setImage(with: URL(string: url))
        }
        
        titleLabel.text = track.name
        artistLabel.text = track.artists.first?.name
    }
    
    private func updateContent(index: Int) {
        let selectedTrack = tracks?[index]
        
        guard let currentTrack = selectedTrack else {
            return
        }
        
        if let url = coverURLString {
            coverImageView.sd_setImage(with: URL(string: url))
        }
        
        titleLabel.text = currentTrack.name
        artistLabel.text = currentTrack.artists.first?.name
    }
    
    private func startPlaying(track: Track? = nil, tracks: [Track]? = nil) {
        if let selectedTrack = track, let url = URL(string: selectedTrack.preview_url ?? "") {
            player = AVPlayer(url: url)
            player?.volume = 0.25
            volumeSlider.value = player!.volume
            
            self.track = selectedTrack
            self.tracks = []
            player?.play()
        }
        
        if let selectedTracks = tracks {
            queue = AVQueuePlayer(items: selectedTracks.compactMap({ track in
                guard let url = URL(string: track.preview_url ?? "") else {
                    return nil
                }
                return AVPlayerItem(url: url)
            }))
            
            queue?.volume = 0.25
            volumeSlider.value = queue!.volume
            queue?.play()
            
            updateContent(index: 0)
        }
    }
    
    @objc private func setVolume(_ sender: UISlider) {
        player?.volume = sender.value
        queue?.volume = sender.value
    }
    
    @objc private func playPauseTrack(_ sender: UIButton) {
        if let player = player {
            if player.timeControlStatus == .playing {
                let image = UIImage(systemName: "arrowtriangle.forward.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.white, renderingMode: .alwaysOriginal)
                player.pause()
                playPauseButton.setImage(image, for: .normal)
            } else if player.timeControlStatus == .paused {
                let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.white, renderingMode: .alwaysOriginal)
                player.play()
                playPauseButton.setImage(image, for: .normal)
            }
        } else if let player = queue {
            if player.timeControlStatus == .playing {
                let image = UIImage(systemName: "arrowtriangle.forward.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.white, renderingMode: .alwaysOriginal)
                player.pause()
                playPauseButton.setImage(image, for: .normal)
            } else if player.timeControlStatus == .paused {
                let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.white, renderingMode: .alwaysOriginal)
                player.play()
                playPauseButton.setImage(image, for: .normal)
            }
        }
    }
    
    @objc private func goToNextTrack(_ sender: UIButton) {
        guard let tracks = tracks else {
            return
        }
        
        if tracks.isEmpty {
            player?.pause()
        }
        
        if let player = queue {
            player.advanceToNextItem()
            index += 1
            
            if index < tracks.count {
                updateContent(index: index)
            }
        }
    }
    
    @objc private func goToPreviousTrack(_ sender: UIButton) {
        guard let tracks = tracks else {
            return
        }
        
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        }
        
        if let firstTrack = queue?.items().first {
            index -= 1
            queue?.pause()
            queue?.replaceCurrentItem(with: queue?.items()[index])
//            queue?.pause()
//            queue?.removeAllItems()
//            queue = AVQueuePlayer(items: [firstTrack])
            queue?.play()
            queue?.volume = 0.25
            volumeSlider.value = queue!.volume
        }
    }
}
