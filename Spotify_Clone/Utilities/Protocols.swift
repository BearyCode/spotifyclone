//
//  Protocols.swift
//  Spotify_Clone
//
//  Created by BearyCode on 27.02.24.
//

import UIKit

protocol HeaderActionsDelegate: AnyObject {
    func playAllTracks(_ sender: UIButton)
}

protocol PlaylistHeaderActionsDelegate: AnyObject, HeaderActionsDelegate {
    func savePlaylist(_ sender: UIButton)
}

protocol AlbumHeaderActionsDelegate: AnyObject, HeaderActionsDelegate {
    func saveAlbum(_ sender: UIButton)
}

protocol MainHeaderDelegate: AnyObject {
    func openProfile(_ sender: UIButton)
}
