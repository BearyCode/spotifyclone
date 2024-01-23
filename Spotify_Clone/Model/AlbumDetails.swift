//
//  AlbumDetails.swift
//  Spotify_Clone
//
//  Created by BearyCode on 22.01.24.
//

import Foundation

struct AlbumDetails: Codable {
    let album_type: String
    let external_urls: [String: String]
    let id: String
    let images: [Image]
    let name: String
    let artists: [Artist]
    let tracks: TrackResponse
}
