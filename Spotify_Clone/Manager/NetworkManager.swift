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
    
    private let clientID = "ADD CLIENT ID"
    private let clientSecret = "ADD CLIENT SECRET"
    private let scope = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    private let redirectURI = "ADD URL"
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
    
    private var tokenExpiration: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var needToRefresh: Bool {
        guard let expirationTime = tokenExpiration else {
            return false
        }
        
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationTime
    }
    
    private var isRefreshingToken = false
    
    private init() {
            
    }
    
    private func saveToken(authResponse: AuthorizationResponse) {
        let exprDate = Date().addingTimeInterval(TimeInterval(authResponse.expires_in))
        
        UserDefaults.standard.setValue(authResponse.access_token, forKey: "accessToken")
        UserDefaults.standard.setValue(exprDate, forKey: "expirationDate")
        
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
    
    public func logout(completion: (Bool) -> Void) {
        UserDefaults.standard.setValue(nil, forKey: "accessToken")
        UserDefaults.standard.setValue(nil, forKey: "refreshToken")
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
        createAPIRequest(url: URL(string: "\(apiURL)/browse/featured-playlists?limit=20" ), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        createAPIRequest(url: URL(string: "\(apiURL)/browse/new-releases?limit=20" ), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
    
    public func getRecomendedGenres(completion: @escaping ((Result<GenreResponse, Error>) -> Void)) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(GenreResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecomendedTracks(genres: Set<String>, completion: @escaping ((Result<CustomTracksResponse, Error>) -> Void)) {
        let seeds = genres.joined(separator: ",")
        
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/recommendations?limit=20&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CustomTracksResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getAlbumTracks(album: Album, completion: @escaping (Result<AlbumDetails, Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/albums/\(album.id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AlbumDetails.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getPlaylistTracks(playlist: Playlist, completion: @escaping (Result<PlaylistDetails, Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/playlists/\(playlist.id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistDetails.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getUserSavedArtists(completion: @escaping (Result<[Artist], Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/me/following?type=artist"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                
                do {
                    let result = try JSONDecoder().decode(LibraryArtistResponse.self, from: data)
                    completion(.success(result.artists.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getUserSavedAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/me/albums"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(LibraryAlbumResponse.self, from: data)
                    completion(.success(result.items.compactMap({$0.album})))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getUserSavedPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/me/playlists"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistResponse.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/browse/categories"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryDetails(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/browse/categories/\(category.id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CategoryPlaylist.self, from: data)
                    completion(.success(result.playlists.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getArtistTopTracks(artist: Artist, completion: @escaping (Result<[Track], Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/artists/\(artist.id)/top-tracks?limit=5&market=de"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CustomTracksResponse.self, from: data)
                    completion(.success(result.tracks))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getArtistAlbums(artist: Artist, completion: @escaping (Result<[Album], Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/artists/\(artist.id)/albums"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AlbumResponse.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRelatedArtists(artist: Artist, completion: @escaping (Result<[Artist], Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/artists/\(artist.id)/related-artists"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RelatedArtistResponse.self, from: data)
                    completion(.success(result.artists))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getSearchResults(query: String, completion: @escaping (Result<SearchResultResponse, Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/search?limit=10&type=track,artist,album,playlist&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/me/albums?ids=\(album.id)"), type: .PUT) { request in
            var req = request
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: req) { data, response, error in
                guard let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode, error == nil else {
                    return
                }
                
                completion(statusCode == 200)
            }
            task.resume()
        }
    }
    
    public func savePlaylist(playlist: Playlist, completion: @escaping (Bool) -> Void) {
        createAPIRequest(url: URL(string: "https://api.spotify.com/v1/playlists/\(playlist.id)/followers"), type: .PUT) { request in
            var req = request
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: req) { data, response, error in
                guard let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode, error == nil else {
                    return
                }
                
                completion(statusCode == 200)
            }
            task.resume()
        }
    }
    
    public func createPlaylist(playlistName: String, completion: @escaping (Bool) -> Void) {
        getCurrentUserProfile { result in
            switch result {
            case .success(let user):
                self.createAPIRequest(url: URL(string: "https://api.spotify.com/v1/users/\(user.id)/playlists"), type: .POST) { request in
                    var req = request
                    let json = ["name": playlistName]
                    req.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    
                    let task = URLSession.shared.dataTask(with: req) { data, response, error in
                        guard let data = data, error == nil else {
                            return
                        }
                        
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        } catch {
                            completion(false)
                        }
                    }
                    task.resume()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
