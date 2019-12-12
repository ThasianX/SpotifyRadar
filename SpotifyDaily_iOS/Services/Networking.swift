import Foundation
import RxSwift

// MARK: Constants

internal let apiTokenEndpointURL = "https://accounts.spotify.com/api/token"
internal let profileServiceEndpointURL = "https://api.spotify.com/v1/me"
internal let topArtistsEndpointURL = "https://api.spotify.com/v1/me/top/artists"
internal let topTracksEndpointURL = "https://api.spotify.com/v1/me/top/tracks"
internal let recentlyPlayedEndpointURL = "https://api.spotify.com/v1/me/player/recently-played"

class Networking {
    internal func createSignInResponse(code: String,
                                       redirectURL: URL,
                                       clientID: String,
                                       clientSecret: String) -> Observable<SignInResponse>{
        let requestBody = "code=\(code)&grant_type=authorization_code&redirect_uri=\(redirectURL.absoluteString)"
        
        return authRequest(requestBody: requestBody, clientID: clientID, clientSecret: clientSecret)
            .flatMap { tokenResponse -> Observable<SignInResponse> in
                let signInResponse = SignInResponse(accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken, expirationDate: Date(timeIntervalSinceNow: tokenResponse.expiresIn))
                return Observable.just(signInResponse)
        }
    }
    
    internal func renewSession(session: Session?,
                               clientID: String,
                               clientSecret: String) -> Observable<Session> {
        guard let session = session, let refreshToken = session.token.refreshToken else {
            fatalError("No current session exists")
        }
        
        let requestBody = "grant_type=refresh_token&refresh_token=\(refreshToken)"
        
        return authRequest(requestBody: requestBody, clientID: clientID, clientSecret: clientSecret)
            .flatMap { tokenResponse -> Observable<Session> in
                let session = Session(
                    token: Token(accessToken: tokenResponse.accessToken,
                                 refreshToken: session.token.refreshToken,
                                 expirationDate: Date(timeIntervalSinceNow: tokenResponse.expiresIn)),
                    userId: session.userId)
                
                Logger.info("Session has been renewed.")
                
                return Observable.just(session)
        }
    }
    
    internal func artistRequest(accessToken: String?, artistURL: URL) -> Observable<ArtistEndpointResponse> {
        guard let accessToken = accessToken else {
            fatalError("Unable to retrieve artist due to invalid access token")
        }
        
        return Observable<ArtistEndpointResponse>.create { observer in
            var urlRequest = URLRequest(url: artistURL)
            let authHeaderValue = "Bearer \(accessToken)"
            urlRequest.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                do {
                    let artistResponse = try JSONDecoder().decode(ArtistEndpointResponse.self, from: data ?? Data())
                    observer.onNext(artistResponse)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        .observeOn(MainScheduler.instance)
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    internal func userRecentlyPlayedRequest(accessToken: String?, limit: Int) -> Observable<RecentlyPlayedTracksEndpointResponse> {
        guard let accessToken = accessToken else {
            fatalError("Unable to retrieve recently played due to invalid access token")
        }
        
        return Observable<RecentlyPlayedTracksEndpointResponse>.create { observer in
            var recentlyPlayedURL = URL(string: recentlyPlayedEndpointURL)!
            let queryItems = [URLQueryItem(name: "limit", value: String(limit))]
            recentlyPlayedURL.appending(queryItems)
            
            Logger.info("URL created: \(recentlyPlayedURL.absoluteString)")
            
            var urlRequest = URLRequest(url: recentlyPlayedURL)
            let authHeaderValue = "Bearer \(accessToken)"
            urlRequest.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                do {
                    let trackResponse = try JSONDecoder().decode(RecentlyPlayedTracksEndpointResponse.self, from: data ?? Data())
                    observer.onNext(trackResponse)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    internal func userTopArtistsRequest(accessToken: String?, timeRange: String, limit: Int) -> Observable<TopArtistsEndpointResponse> {
        guard let accessToken = accessToken else {
            fatalError("Unable to retrieve top artists due to invalid access token")
        }
        
        return Observable<TopArtistsEndpointResponse>.create { observer in
            var topArtistsURL = URL(string: topArtistsEndpointURL)!
            let queryItems = [URLQueryItem(name: "time_range", value: timeRange),
                              URLQueryItem(name: "limit", value: String(limit))]
            topArtistsURL.appending(queryItems)
            
            Logger.info("URL created: \(topArtistsURL.absoluteString)")
            
            var urlRequest = URLRequest(url: topArtistsURL)
            let authHeaderValue = "Bearer \(accessToken)"
            urlRequest.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                do {
                    let artistResponse = try JSONDecoder().decode(TopArtistsEndpointResponse.self, from: data ?? Data())
                    observer.onNext(artistResponse)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    internal func userTopTracksRequest(accessToken: String?, timeRange: String, limit: Int) -> Observable<TopTracksEndpointResponse> {
        guard let accessToken = accessToken else {
            fatalError("Unable to retrieve top tracks due to invalid access token")
        }
        
        return Observable<TopTracksEndpointResponse>.create { observer in
            var topTracksURL = URL(string: topTracksEndpointURL)!
            let queryItems = [URLQueryItem(name: "time_range", value: timeRange),
                              URLQueryItem(name: "limit", value: String(limit))]
            topTracksURL.appending(queryItems)
            
            Logger.info("URL created: \(topTracksURL.absoluteString)")
            
            var urlRequest = URLRequest(url: topTracksURL)
            let authHeaderValue = "Bearer \(accessToken)"
            urlRequest.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                do {
                    let trackResponse = try JSONDecoder().decode(TopTracksEndpointResponse.self, from: data ?? Data())
                    observer.onNext(trackResponse)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    internal func userProfileRequest(accessToken: String?) -> Observable<ProfileEndpointResponse> {
        guard let accessToken = accessToken else {
            fatalError("Unable to retrieve user profile due to invalid access token")
        }
        
        return Observable<ProfileEndpointResponse>.create { observer in
            let profileURL = URL(string: profileServiceEndpointURL)!
            var urlRequest = URLRequest(url: profileURL)
            let authHeaderValue = "Bearer \(accessToken)"
            urlRequest.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                do {
                    let profileResponse = try JSONDecoder().decode(ProfileEndpointResponse.self, from: data ?? Data())
                    observer.onNext(profileResponse)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        .observeOn(MainScheduler.instance)
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    private func authRequest(requestBody: String,
                             clientID: String,
                             clientSecret: String) -> Observable<TokenEndpointResponse> {
        guard let authString = "\(clientID):\(clientSecret)"
            .data(using: .ascii)?.base64EncodedString(options: .endLineWithLineFeed) else {
                fatalError("Login configuration missing")
        }
        
        return Observable<TokenEndpointResponse>.create { observer in
            let endpoint = URL(string: apiTokenEndpointURL)!
            var urlRequest = URLRequest(url: endpoint)
            urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            urlRequest.httpMethod = "POST"
            
            let authHeaderValue = "Basic \(authString)"
            urlRequest.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = requestBody.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                do {
                    let authResponse = try JSONDecoder().decode(TokenEndpointResponse.self, from: data ?? Data())
                    observer.onNext(authResponse)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        .observeOn(MainScheduler.instance)
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
}

public enum EndpointError: Error {
    case missingAccessToken
}
