//
//  CategoryResponse.swift
//  Spotify_Clone
//
//  Created by BearyCode on 27.01.24.
//

import Foundation

struct CategoriesResponse: Codable {
    let categories: CategoryRepsonse
}

struct CategoryRepsonse: Codable {
    let items: [Category]
}
