//
//  TopTracksAndArtistsEndpointResponse.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/2/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

fileprivate struct TopArtistsEndpointModel: Decodable {
    struct Item: Decodable {
        var external_urls: ExternalUrls
        var followers: Followers
        var genres: [String]
        var images: [Image]
        var name: String
    }

    struct ExternalUrls: Decodable {
        var spotify: String
    }

    struct Followers: Decodable {
        var total: Int
    }

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
            let url = URL(string: item.images.first!.url)!
            let followers = item.followers.total
            let externalURL = URL(string: item.external_urls.spotify)!
            let artist = Artist(name: name, image: url, followers: followers, externalURL: externalURL)
            
            self.artists.append(artist)
        }
    }
}
