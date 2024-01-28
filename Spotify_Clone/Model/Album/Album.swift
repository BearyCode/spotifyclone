//
//  Album.swift
//  SpotifyClone
//
//  Created by BearyCode on 17.01.24.
//

import Foundation

struct Album: Codable {
    let album_type: String
    let total_tracks: Int
    let external_urls: [String: String]
    let id: String
    let images: [Image]
    let name: String
    let release_date: String
    let artists: [Artist]
}
