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

internal class URLBuilder {

    let clientID: String
    let clientSecret: String
    let redirectURL: URL

    // MARK: Lifecycle

    internal init(clientID: String, clientSecret: String, redirectURL: URL) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURL = redirectURL
    }

    // MARK: URL functions

    internal func authenticationURL(type: AuthenticationURLType, scopes: [Scope]) -> URL? {
        let endpoint = type.rawValue
        let scopeStrings = scopes.map({$0.rawValue})

        var params = ["client_id": clientID,
                      "redirect_uri": redirectURL.absoluteString,
                      "response_type": "code",
                      "show_dialog": "true",
                      "nosignup": "true",
                      "nolinks": "true",
                      "utm_source": Constants.AuthUTMSourceQueryValue,
                      "utm_medium": Constants.AuthUTMMediumCampaignQueryValue,
                      "utm_campaign": Constants.AuthUTMMediumCampaignQueryValue]

        if scopeStrings.count > 0 {
            params["scope"] = scopeStrings.joined(separator: " ")
        }

        let pairs = params.map {"\($0)=\($1)"}
        let pairsString = pairs.joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ??  String()

        let loginPageURLString = "\(endpoint)authorize?\(pairsString)"
        return URL(string: loginPageURLString)
    }

    internal func parse(url: URL) -> (code: String?, error: Bool) {
        var code: String?
        var error = false
        let components = URLComponents(string: url.absoluteString)

        if let queryItems = components?.queryItems {
            for query in queryItems {
                if query.name == "code" {
                    code = query.value
                } else if query.name == "error" {
                    error = true
                }
            }
        }
        if code == nil {
            error = true
        }
        return (code: code, error: error)
    }

    internal func canHandleURL(_ url: URL) -> Bool {
        let redirectURLString = redirectURL.absoluteString
        return url.absoluteString.hasPrefix(redirectURLString)
    }

}

internal enum AuthenticationURLType: String {
    case app = "spotify-action://"
    case web = "https://accounts.spotify.com/"
}
