//
//  AuthorizationResponse.swift
//  SpotifyClone
//
//  Created by BearyCode on 13.01.24.
//

import Foundation

struct AuthorizationResponse: Codable {
    let access_token: String
    let token_type: String
    let scope: String
    let expires_in : Int
    let refresh_token: String?
}
