// Copyright (c) 2017 Spotify AB.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

// MARK: Constants

internal let apiTokenEndpointURL = "https://accounts.spotify.com/api/token"
internal let profileServiceEndpointURL = "https://api.spotify.com/v1/me"

// MARK: API responses

internal struct TokenEndpointResponse: Codable {

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }

    let accessToken: String
    let expiresIn: Double
    let refreshToken: String?
}

internal struct ProfileEndpointResponse {
    enum RootKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case followers, href, id, images, product, type, uri
    }

    enum ExplicitContentKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }

    enum ExternalUrlsKeys: String, CodingKey {
        case spotify
    }

    enum FollowersKeys: String, CodingKey {
        case href, total
    }

    enum ImagesKeys: String, CodingKey {
        case height, url, width
    }
    
    let country: String
    let displayName: String
    let filterEnabled: Bool
    let profileUrl: String
    let numberOfFollowers: Int
    let endpointUrl: String
    let id: String
//    let avatarUrl: URL
//    let subscriptionLevel: String
//    let uriUrl: URL
}

extension ProfileEndpointResponse: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        country = try container.decode(String.self, forKey: .country)
        displayName = try container.decode(String.self, forKey: .displayName)

        let explicitContentContainer = try container.nestedContainer(keyedBy: ExplicitContentKeys.self, forKey: .explicitContent)
        filterEnabled = try explicitContentContainer.decode(Bool.self, forKey: .filterEnabled)

        let externalUrlsContainer = try container.nestedContainer(keyedBy: ExternalUrlsKeys.self, forKey: .externalUrls)
        profileUrl = try externalUrlsContainer.decode(String.self, forKey: .spotify)

        let followersContainer = try container.nestedContainer(keyedBy: FollowersKeys.self, forKey: .followers)
        numberOfFollowers = try followersContainer.decode(Int.self, forKey: .total)

        endpointUrl = try container.decode(String.self, forKey: .href)

        id = try container.decode(String.self, forKey: .id)

//        var imagesContainer = try container.nestedUnkeyedContainer(forKey: .images)
//        var imagesArray = [URL]()
//        while !imagesContainer.isAtEnd {
//            let imageContainer = try imagesContainer.nestedContainer(keyedBy: ImagesKeys.self)
//            let imageUrlString = try imageContainer.decode(String.self, forKey: .url)
//            let imageUrl = URL(string: imageUrlString)!
//            imagesArray.append(imageUrl)
//        }
//        guard let image = imagesArray.first else {
//            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath + [RootKeys.images], debugDescription: "images cannot be empty"))
//        }
//        avatarUrl = image
//
//        subscriptionLevel = try container.decode(String.self, forKey: .product)
//
//        let uriUrlString = try container.decode(String.self, forKey: .uri)
//        uriUrl = URL(string: uriUrlString)!
        
    }
}

internal class Networking {

    internal class func createSession(code: String,
                                      redirectURL: URL,
                                      clientID: String,
                                      clientSecret: String,
                                      completion: @escaping (Session?, Error?) -> Void) {
        let requestBody = "code=\(code)&grant_type=authorization_code&redirect_uri=\(redirectURL.absoluteString)"
        Networking.authRequest(requestBody: requestBody,
                               clientID: clientID,
                               clientSecret: clientSecret) { response, error in
            if let response = response, error == nil {
                Networking.userProfileRequest(accessToken: response.accessToken, completion: { profileResponse in
                    if let profileResponse = profileResponse {
                        let user = User(country: profileResponse.country,
                                        displayName: profileResponse.displayName,
                                        filterEnabled: profileResponse.filterEnabled,
                                        profileUrl: profileResponse.profileUrl,
                                        numberOfFollowers: profileResponse.numberOfFollowers,
                                        endpointUrl: profileResponse.endpointUrl,
                                        id: profileResponse.id)
                        let session = Session(user: user,
                                              accessToken: response.accessToken,
                                              refreshToken: response.refreshToken,
                                              expirationDate: Date(timeIntervalSinceNow: response.expiresIn))
                        DispatchQueue.main.async {
                            completion(session, nil)
                        }
                    }
                })
            } else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }

    internal class func renewSession(session: Session?,
                                     clientID: String,
                                     clientSecret: String,
                                     completion: @escaping (Session?, Error?) -> Void) {
        guard let session = session, let refreshToken = session.refreshToken else {
            DispatchQueue.main.async {
                completion(nil, LoginError.noSession)
            }
            return
        }
        let requestBody = "grant_type=refresh_token&refresh_token=\(refreshToken)"

        Networking.authRequest(requestBody: requestBody,
                               clientID: clientID,
                               clientSecret: clientSecret) { response, error in
            if let response = response, error == nil {
                let session = Session(user: session.user,
                                      accessToken: response.accessToken,
                                      refreshToken: session.refreshToken,
                                      expirationDate: Date(timeIntervalSinceNow: response.expiresIn))
                DispatchQueue.main.async {
                    completion(session, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }

    // MARK: Private

    internal class func userProfileRequest(accessToken: String?,
                                               completion: @escaping (ProfileEndpointResponse?) -> Void) {
        guard let accessToken = accessToken else {
            completion(nil)
            return
        }
        let profileURL = URL(string: profileServiceEndpointURL)!
        var urlRequest = URLRequest(url: profileURL)
        let authHeaderValue = "Bearer \(accessToken)"
        urlRequest.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest,
                                              completionHandler: { (data, _, error) in
            if let data = data, error == nil {
                let profileResponse = try? JSONDecoder().decode(ProfileEndpointResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(profileResponse)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
        task.resume()
    }

    internal class func authRequest(requestBody: String,
                                    clientID: String,
                                    clientSecret: String,
                                    completion: @escaping (TokenEndpointResponse?, Error?) -> Void) {
        guard let authString = "\(clientID):\(clientSecret)"
            .data(using: .ascii)?.base64EncodedString(options: .endLineWithLineFeed) else {
            DispatchQueue.main.async {
                completion(nil, LoginError.configurationMissing)
            }
            return
        }
        let endpoint = URL(string: apiTokenEndpointURL)!
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        urlRequest.httpMethod = "POST"

        let authHeaderValue = "Basic \(authString)"
        urlRequest.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = requestBody.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: urlRequest,
                                              completionHandler: { (data, _, error) in
            if let data = data,
                let authResponse = try? JSONDecoder().decode(TokenEndpointResponse.self, from: data), error == nil {
                DispatchQueue.main.async {
                    completion(authResponse, error)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        })
        task.resume()
    }

}

// MARK: Extensions

private extension String {
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
}
