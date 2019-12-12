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
    
    weak internal var safariVC: SFSafariViewController?
    internal var urlBuilder: URLBuilder?
    private let disposeBag = DisposeBag()
    
    private var configuration: Configuration
    private let sessionService: SessionService
    private let networkingClient: Networking
    
    init(configuration: Configuration, sessionService: SessionService, networkingClient: Networking) {
        self.sessionService = sessionService
        self.networkingClient = networkingClient
        self.configuration = configuration
        
        self.urlBuilder = URLBuilder(clientID: configuration.clientID,
                                     clientSecret: configuration.clientSecret,
                                     redirectURL: configuration.redirectURL,
                                     showDialog: true)
    }
    
    // MARK: Interface
    
    /// Process URL and attempts to create a session.
    ///
    /// - Parameters:
    ///   - url: url to handle.
    ///   - completion: Returns an optional error or nil if successful.
    /// - Returns: Whether or not the URL was handled.
    public func applicationOpenURL(_ url: URL) -> Bool {
        guard let urlBuilder = urlBuilder else {
            return false
        }
        
        guard urlBuilder.canHandleURL(url) else {
            return false
        }
        
        safariVC?.dismiss(animated: true, completion: nil)
        
        let parsedURL = urlBuilder.parse(url: url)
        if let code = parsedURL.code, !parsedURL.error {
            networkingClient.createSignInResponse(code: code,
                                                  redirectURL: configuration.redirectURL,
                                                  clientID: configuration.clientID,
                                                  clientSecret: configuration.clientSecret)
                .bind(onNext: { [weak self] response in
                    Logger.info("Signing user in")
                    self?.sessionService.signIn(response: response)
                })
                .disposed(by: disposeBag)
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
