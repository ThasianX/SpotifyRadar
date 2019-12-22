// Credits: https://github.com/spotify/SpotifyLogin/blob/master/Sources/SpotifyLoginPresenter.swift

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
