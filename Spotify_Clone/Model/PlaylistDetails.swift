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
    let followers: Followers
    let id: String
    let images: [Image]
    let name: String
    let owner: Owner
    let tracks: PlaylistDetailsResponse
}
