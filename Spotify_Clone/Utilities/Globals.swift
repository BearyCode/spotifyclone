//
//  Globals.swift
//  Spotify_Clone
//
//  Created by BearyCode on 03.03.24.
//

import Foundation

struct Globals {
    
    static let shared = Globals()

    public func followerNumberFormatter(followerNumber: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let formattedNumber = formatter.string(from: NSNumber(value: followerNumber)) {
            return formattedNumber
        }
        
        return ""
    }
}
