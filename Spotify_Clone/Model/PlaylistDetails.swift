//
//  PlaylistDetails.swift
//  Spotify_Clone
//
//  Created by BearyCode on 22.01.24.
//

import Foundation

struct PlaylistDetails: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [Image]
    let name: String
    let tracks: PlaylistDetailsResponse
}
