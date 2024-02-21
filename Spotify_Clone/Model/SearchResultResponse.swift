//
//  SearchResultResponse.swift
//  Spotify_Clone
//
//  Created by BearyCode on 21.02.24.
//

import Foundation

struct SearchResultResponse: Codable {
    let tracks: SearchResultTrackResponse
    let artists: SearchResultArtistResponse
    let albums: SearchResultAlbumResponse
    let playlists: SearchResultPlaylistResponse
}


struct SearchResultTrackResponse: Codable {
    let items: [Track]
}

struct SearchResultArtistResponse: Codable {
    let items: [Artist]
}

struct SearchResultAlbumResponse: Codable {
    let items: [Album]
}

struct SearchResultPlaylistResponse: Codable {
    let items: [Playlist]
}
