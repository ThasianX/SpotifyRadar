//
//  ArtistSearchEndpointResponse.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/15/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

fileprivate struct ArtistSearchEndpointModel: Decodable {
    // MARK: - Artists
    struct Artists: Codable {
        let items: [Item]
    }

    // MARK: - Item
    struct Item: Codable {
        let externalUrls: ExternalUrls
        let followers: Followers
        let genres: [String]
        let href: String
        let id: String
        let images: [Image]
        let name: String
        let popularity: Int
        let type, uri: String

        enum CodingKeys: String, CodingKey {
            case externalUrls = "external_urls"
            case followers, genres, href, id, images, name, popularity, type, uri
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
        let height: Int
        let url: String
        let width: Int
    }
    
    var artists: Artists
}

struct ArtistSearchEndpointResponse: Decodable {
    var artists = [Artist]()
    
    init(from decoder: Decoder) throws {
        let response = try ArtistSearchEndpointModel(from: decoder)
        
        for item in response.artists.items {
            let name = item.name
            let id = item.id
            let url = URL(string: item.images.first!.url)!
            let followers = item.followers.total
            let externalURL = URL(string: item.externalUrls.spotify)!
            let artist = Artist(name: name, id: id,image: url, followers: followers, externalURL: externalURL)
            
            self.artists.append(artist)
        }
    }
}
