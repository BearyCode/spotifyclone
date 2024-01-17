//
//  Playlist.swift
//  SpotifyClone
//
//  Created by BearyCode on 13.01.24.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [Image]
    let name: String
    let owner: Owner
}
