//
//  TopTracksAndArtistsEndpointResponse.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/2/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

fileprivate struct TopArtistsEndpointModel: Decodable {

    // MARK: - Item
    struct Item: Codable {
        let externalUrls: ExternalUrls
        let followers: Followers
        let genres: [String]
        let images: [Image]
        let name: String

        enum CodingKeys: String, CodingKey {
            case externalUrls = "external_urls"
            case followers, genres, images, name
        }
    }

    // MARK: - ExternalUrls
    struct ExternalUrls: Codable {
        let spotify: String
    }

    // MARK: - Followers
    struct Followers: Codable {
        let total: Int
    }

    // MARK: - Image
    struct Image: Codable {
        let url: String
    }
    
    var items: [Item]
}

struct TopArtistsEndpointResponse: Decodable {
    var artists = [Artist]()
    
    init(from decoder: Decoder) throws {
        let response = try TopArtistsEndpointModel(from: decoder)
        
        for item in response.items {
            let name = item.name
            let image = item.images.first!.url
            let url = URL(string: image)!
            let artist = Artist(name: name, image: url)
            Logger.info("Artist: \(artist)")
            
            self.artists.append(artist)
        }
    }
}
