//
//  Owner.swift
//  SpotifyClone
//
//  Created by BearyCode on 13.01.24.
//

import Foundation

struct Owner: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
