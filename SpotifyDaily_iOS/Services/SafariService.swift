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

class SafariService {
    
    private let spotifyLogin: SpotifyLogin
    
    init(spotifyLogin: SpotifyLogin) {
        self.spotifyLogin = spotifyLogin
    }

    /// Trigger log in flow.
    ///
    /// - Parameters:
    ///   - viewController: The view controller that orignates the log in flow.
    ///   - scopes: A list of requested scopes and permissions.
    func login(from viewController: (UIViewController), scopes: [Scope]) {
        let urlBuilder = spotifyLogin.urlBuilder
        if let webAuthenticationURL = urlBuilder?.authenticationURL(type: .web, scopes: scopes) {
            viewController.definesPresentationContext = true
            let safariViewController: SFSafariViewController = SFSafariViewController(url: webAuthenticationURL)
            safariViewController.modalPresentationStyle = .pageSheet
            let delegate = SafariDelegate()
            safariViewController.delegate = delegate
            viewController.present(safariViewController, animated: true, completion: nil)
            spotifyLogin.safariVC = safariViewController
        } else {
            assertionFailure("Unable to login.")
        }
    }
    
    /// Returns a safari view controller for a given url. Requires: URL is not nil
    func presentSafari(from viewController: (UIViewController), for url: URL){
        return viewController.present(SFSafariViewController(url: url), animated: true)
    }

}
