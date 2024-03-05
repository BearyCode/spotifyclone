//
//  User.swift
//  Spotify_Clone
//
//  Created by BearyCode on 25.02.24.
//

import Foundation

struct User: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    let followers: Followers
    let id: String
    let product: String
    let images: [Image]
}
