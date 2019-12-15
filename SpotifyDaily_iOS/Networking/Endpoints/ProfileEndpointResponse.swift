//
//  ProfileEndpointResponse.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct ProfileEndpointResponse {
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
    let email: String
    let filterEnabled: Bool
    let profileUrl: String
    let numberOfFollowers: Int
    let endpointUrl: String
    let id: String
    let avatarUrl: String
    let subscriptionLevel: String
    let uriUrl: String
}

extension ProfileEndpointResponse: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        country = try container.decode(String.self, forKey: .country)
        displayName = try container.decode(String.self, forKey: .displayName)
        if let _email = try container.decode(String?.self, forKey: .email) {
            email = _email
        } else {
            email = "None - Facebook"
        }
        
        let explicitContentContainer = try container.nestedContainer(keyedBy: ExplicitContentKeys.self, forKey: .explicitContent)
        filterEnabled = try explicitContentContainer.decode(Bool.self, forKey: .filterEnabled)

        let externalUrlsContainer = try container.nestedContainer(keyedBy: ExternalUrlsKeys.self, forKey: .externalUrls)
        profileUrl = try externalUrlsContainer.decode(String.self, forKey: .spotify)

        let followersContainer = try container.nestedContainer(keyedBy: FollowersKeys.self, forKey: .followers)
        numberOfFollowers = try followersContainer.decode(Int.self, forKey: .total)

        endpointUrl = try container.decode(String.self, forKey: .href)

        id = try container.decode(String.self, forKey: .id)

        var imagesContainer = try container.nestedUnkeyedContainer(forKey: .images)
        var imagesArray = [String]()
        while !imagesContainer.isAtEnd {
            let imageContainer = try imagesContainer.nestedContainer(keyedBy: ImagesKeys.self)
            let imageUrl = try imageContainer.decode(String.self, forKey: .url)
            imagesArray.append(imageUrl)
        }
        
        if imagesArray.count == 0 {
            imagesArray.append("")
        }
        
        avatarUrl = imagesArray.first!

        subscriptionLevel = try container.decode(String.self, forKey: .product)

        uriUrl = try container.decode(String.self, forKey: .uri)
    }
}
