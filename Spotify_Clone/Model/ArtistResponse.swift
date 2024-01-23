//
//  ArtistResponse.swift
//  Spotify_Clone
//
//  Created by BearyCode on 23.01.24.
//

import Foundation

struct ArtistResponse: Codable {
    let items: [Artist]
}

struct LibraryArtistResponse: Codable {
    let artists: ArtistResponse
}
