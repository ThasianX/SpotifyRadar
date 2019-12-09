//
//  ArtistEndpointResponse.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/9/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

fileprivate struct ArtistEndpointModel: Decodable {
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

struct ArtistEndpointResponse: Decodable {
    var artist: Artist?
    
    init(from decoder: Decoder) throws {
        let response = try ArtistEndpointModel(from: decoder)
        
        let name = response.name
        let image = URL(string: response.images.first!.url)!
        let followers = response.followers.total
        let externalURL = URL(string: response.externalUrls.spotify)!
        
        artist = Artist(name: name, image: image, followers: followers, externalURL: externalURL)
    }
}
