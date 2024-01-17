//
//  NetworkManager.swift
//  SpotifyClone
//
//  Created by BearyCode on 13.01.24.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case PUT
    case POST
    case DELETE
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let clientID = "c2dc2d96c5c94d7cae51af547feafeeb"
    private let clientSecret = "5d0513598b3d4603b71ec865b196e034"
    private let scope = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    private let redirectURI = "https://www.bearycode.com"
    private let tokenURL = "https://accounts.spotify.com/api/token"
    
    private var apiURL = "https://api.spotify.com/v1"
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    var loginURL: URL? {
        let url = "https://accounts.spotify.com/authorize?response_type=code&client_id=\(clientID)&scope=\(scope)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: url)
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refreshToken")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var needToRefresh: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    private var isRefreshingToken = false
    
    private init() {
    }
    
    private func saveToken(authResponse: AuthorizationResponse) {
        UserDefaults.standard.setValue(authResponse.access_token, forKey: "accessToken")
        UserDefaults.standard.setValue(TimeInterval(authResponse.expires_in), forKey: "expirationDate")
        
        if let refresh_token = authResponse.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refreshToken")
        }
    }
    
    func requestAccessToken(code: String, completion: @escaping ((Bool) -> Void)) {
        
        guard let url = URL(string: tokenURL) else {
            return
        }
        
        var authOptions = URLComponents()
        authOptions.queryItems = [URLQueryItem(name: "code", value: code), URLQueryItem(name: "redirect_uri", value: redirectURI), URLQueryItem(name: "grant_type", value: "authorization_code")]
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = authOptions.query?.data(using: .utf8)
        
        let token = "\(clientID):\(clientSecret)"
        let data = token.data(using: .utf8)
        
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthorizationResponse.self, from: data)
                self.saveToken(authResponse: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    func refreshAccessToken(completion: ((Bool) -> Void)?) {
        guard !isRefreshingToken else {
            return
        }
        
        guard needToRefresh else {
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        guard let url = URL(string: tokenURL) else {
            return
        }
        
        isRefreshingToken = true
        
        var authOptions = URLComponents()
        authOptions.queryItems = [URLQueryItem(name: "grant_type", value: "refresh_token"), URLQueryItem(name: "refresh_token", value: refreshToken)]
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = authOptions.query?.data(using: .utf8)
        
        let token = "\(clientID):\(clientSecret)"
        let data = token.data(using: .utf8)
        
        guard let base64String = data?.base64EncodedString() else {
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            self.isRefreshingToken = false
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthorizationResponse.self, from: data)
                self.saveToken(authResponse: result)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    public func validateToken(completion: @escaping (String) -> Void) {
        guard !isRefreshingToken else {
            return
        }
        
        if needToRefresh {
            print("refreshed")
            refreshAccessToken { success in
                if let token = self.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func logout() {
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
    }
    
    private func createAPIRequest(url: URL?, type: HTTPMethod, completionHandler: @escaping (URLRequest) -> Void) {
        NetworkManager.shared.validateToken { token in
            guard let url = url else {
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            
            completionHandler(request)
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylist, Error>) -> Void) {
        createAPIRequest(url: URL(string: "\(apiURL)/browse/featured-playlists?limit=50" ), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylist.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getNewAlbumReleases(completion: @escaping (Result<NewReleases, Error>) -> Void) {
        createAPIRequest(url: URL(string: "\(apiURL)/browse/new-releases?limit=50" ), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleases.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getSeveralShows(completion: @escaping (Result<[Show], Error>) -> Void) {
        createAPIRequest(url: URL(string: "\(apiURL)/browse/shows?limit=50" ), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode([Show].self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
