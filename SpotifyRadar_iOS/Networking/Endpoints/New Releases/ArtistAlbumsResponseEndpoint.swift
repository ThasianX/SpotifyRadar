//
//  ArtistAlbumsResponseEndpoint.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/17/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

fileprivate struct ArtistAlbumsEndpointModel: Decodable {
    // MARK: - Item
    struct Item: Codable {
        let albumGroup, albumType: String
        let artists: [Artist]
        let availableMarkets: [String]
        let externalUrls: ExternalUrls
        let href: String
        let id: String
        let images: [Image]
        let name, releaseDate, releaseDatePrecision, type: String
        let uri: String
        
        enum CodingKeys: String, CodingKey {
            case albumGroup = "album_group"
            case albumType = "album_type"
            case artists
            case availableMarkets = "available_markets"
            case externalUrls = "external_urls"
            case href, id, images, name
            case releaseDate = "release_date"
            case releaseDatePrecision = "release_date_precision"
            case type, uri
        }
    }
    
    // MARK: - Artist
    struct Artist: Codable {
        let externalUrls: ExternalUrls
        let href: String
        let id, name, type, uri: String
        
        enum CodingKeys: String, CodingKey {
            case externalUrls = "external_urls"
            case href, id, name, type, uri
        }
    }
    
    // MARK: - ExternalUrls
    struct ExternalUrls: Codable {
        let spotify: String
    }
    
    // MARK: - Image
    struct Image: Codable {
        let height: Int
        let url: String
        let width: Int
    }
    
    let items: [Item]
}

struct ArtistAlbumsEndpointResponse: Decodable {
    var albums = [Album]()
    
    init(from decoder: Decoder) throws {
        let response = try ArtistAlbumsEndpointModel(from: decoder)
        
        for item in response.items {
            let name = item.name
            let id = item.id
            let href = item.href
            
            let releaseDate = item.releaseDate
            let releasePrecision = item.releaseDatePrecision
            
            var date: Date?
            if releasePrecision == "day" {
                date = releaseDate.toDate(withFormat: "yyyy-MM-dd")
            } else if releasePrecision == "month" {
                date = releaseDate.toDate(withFormat: "yyyy-MM")
            } else if releasePrecision == "year" {
                date = releaseDate.toDate(withFormat: "yyyy")
            }
            
            
            let externalURL = URL(string: item.externalUrls.spotify)!
            
            let album = Album(albumName: name, albumId: id, href: href, releaseDate: date!, externalURL: externalURL)
            
            albums.append(album)
        }
    }
}
