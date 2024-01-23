//
//  Track.swift
//  SpotifyClone
//
//  Created by BearyCode on 17.01.24.
//

import Foundation

struct Track: Codable {
    let album: Album?
    let artists: [Artist]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
    let preview_url: String?
}
