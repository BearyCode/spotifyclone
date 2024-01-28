//
//  Artist.swift
//  SpotifyClone
//
//  Created by BearyCode on 17.01.24.
//

import Foundation

struct Artist: Codable {
    let external_urls: [String: String]
//    let followers: [String: Int]
    let id: String
    var images: [Image]?
    let name: String
}
