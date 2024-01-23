//
//  Episode.swift
//  SpotifyClone
//
//  Created by BearyCode on 17.01.24.
//

import Foundation

struct Episode: Codable {
    let duration_ms: String
    let external_urls: [String: String]
    let id: String
    let images: [Image]
    let name: String
    let release_date : String
    let show: Show
}
