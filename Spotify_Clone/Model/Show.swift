//
//  Show.swift
//  SpotifyClone
//
//  Created by BearyCode on 17.01.24.
//

import Foundation

struct Show: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [Image]
    let name: String
    let publisher: String
    let episodes: EpisodeResponse
}
