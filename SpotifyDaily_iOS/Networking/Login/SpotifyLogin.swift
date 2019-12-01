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
import SafariServices
import RxSwift

/// Spotify login object.
class SpotifyLogin {
    
    private var clientID: String?
    private var clientSecret: String?
    private var redirectURL: URL?
    
    weak internal var safariVC: SFSafariViewController?
    
    internal var urlBuilder: URLBuilder?
    
    private let sessionService: SessionService
    private let networkingClient: Networking
    
    init(sessionService: SessionService, networkingClient: Networking) {
        self.sessionService = sessionService
        self.networkingClient = networkingClient
        
        let redirectURL: URL = URL(string: "spotify-daily-login://")!
        self.configure(clientID: "8cece41fa2cc49a48e66b70cbc7789fc",
                       clientSecret: "89faaf509a5e49569abb3fc93ebe4740",
                       redirectURL: redirectURL)
    }
    
    // MARK: Interface
    
    /// Configure login object.
    ///
    /// - Parameters:
    ///   - clientID: App's client id.
    ///   - clientSecret: App's client secret.
    ///   - redirectURL: App's redirect url.
    private func configure(clientID: String, clientSecret: String, redirectURL: URL, showDialog: Bool? = true) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = redirectURL
        self.urlBuilder = URLBuilder(clientID: clientID,
                                     clientSecret: clientSecret,
                                     redirectURL: redirectURL,
                                     showDialog: showDialog!)
        
        Logger.info("Configured clientID, clientSecret, and redirectURL.")
    }
    
    //    /// Asynchronous call to retrieve the session's auth token. Automatically refreshes if auth token expired.
    //    ///
    //    /// - Parameter completion: Returns the auth token as a string if available and an optional error.
    //    public func getAccessToken(completion:@escaping (String?, Error?) -> Void) {
    //        // If the login object is not fully configured, return an error
    //        guard redirectURL != nil, let clientID = clientID, let clientSecret = clientSecret else {
    //            completion(nil, LoginError.configurationMissing)
    //            return
    //        }
    //        // If there is no session, return an error
    //        guard let session = session else {
    //            completion(nil, LoginError.noSession)
    //            return
    //        }
    //        // If session is valid return access token, otherwsie refresh
    //        if session.token.isValid() {
    //            completion(session.token.accessToken, nil)
    //            return
    //        } else {
    //            Networking.renewSession(session: session,
    //                                    clientID: clientID,
    //                                    clientSecret: clientSecret,
    //                                    completion: { [weak self] session, error in
    //                if let session = session, error == nil {
    //                    self?.session = session
    //                    completion(session.token.accessToken, nil)
    //                } else {
    //                    completion(nil, error)
    //                }
    //            })
    //        }
    //    }
    //
    //    /// Log out of current session.
    //    public func logout() {
    //        SessionLocalStorage.removeSession()
    //        session = nil
    //    }
    
    /// Process URL and attempts to create a session.
    ///
    /// - Parameters:
    ///   - url: url to handle.
    ///   - completion: Returns an optional error or nil if successful.
    /// - Returns: Whether or not the URL was handled.
    public func applicationOpenURL(_ url: URL) -> Bool {
        guard let urlBuilder = urlBuilder,
            let redirectURL = redirectURL,
            let clientID = clientID,
            let clientSecret = clientSecret else {
                return false
        }
        
        guard urlBuilder.canHandleURL(url) else {
            return false
        }
        
        safariVC?.dismiss(animated: true, completion: nil)
        
        let parsedURL = urlBuilder.parse(url: url)
        if let code = parsedURL.code, !parsedURL.error {
            networkingClient.createSignInResponse(code: code,
                                            redirectURL: redirectURL,
                                            clientID: clientID,
                                            clientSecret: clientSecret,
                                            completion: { [weak self] response, error in
                                                DispatchQueue.main.async {
                                                    if error == nil {
                                                        self?.sessionService.signIn(response: response!)
                                                    }
                                                }
            })
        }
        
        return true
    }
    
}

/// Login error
enum LoginError: Error {
    /// Generic error message.
    case general
    /// Spotify Login is not fully configured. Use the configuration function.
    case configurationMissing
    /// There is no valid session. Use the login function.
    case noSession
    /// The url provided to the app can not be handled or parsed.
    case invalidUrl
}
