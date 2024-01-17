//
//  PlaylistResponse.swift
//  SpotifyClone
//
//  Created by BearyCode on 13.01.24.
//

import Foundation

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct FeaturedPlaylist: Codable {
    let playlists: PlaylistResponse
}

struct CategoryPlaylist: Codable {
    let playlists: PlaylistResponse
}
