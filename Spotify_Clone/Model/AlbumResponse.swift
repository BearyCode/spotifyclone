//
//  AlbumResponse.swift
//  SpotifyClone
//
//  Created by BearyCode on 17.01.24.
//

import Foundation

struct AlbumResponse: Codable {
    let items: [Album]
}

struct NewReleases: Codable {
    let albums: AlbumResponse
}
