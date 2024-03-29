//
//  TrackResponse.swift
//  SpotifyClone
//
//  Created by BearyCode on 17.01.24.
//

import Foundation

struct TrackResponse: Codable {
    let items: [Track]
}

struct CustomTracksResponse: Codable {
    let tracks: [Track]
}
