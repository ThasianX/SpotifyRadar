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
    struct Item: Decodable {
        var external_urls: ExternalUrls
        var followers: Followers
        var genres: [String]
        var images: [Image]
        var name: String
    }

    // MARK: - ExternalUrls
    struct ExternalUrls: Decodable {
        var spotify: String
    }

    // MARK: - Followers
    struct Followers: Decodable {
        var total: Int
    }

    // MARK: - Image
    struct Image: Decodable {
        var url: String
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
