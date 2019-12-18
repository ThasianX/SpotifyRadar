//
//  AlbumTracksEndpointResponse.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/18/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

fileprivate struct AlbumTracksEndpointModel: Decodable {
    // MARK: - Item
    struct Item: Codable {
        let artists: [Artist]
        let availableMarkets: [String]
        let discNumber, durationMS: Int
        let explicit: Bool
        let externalUrls: ExternalUrls
        let href: String
        let id: String
        let isLocal: Bool
        let name: String
        let previewURL: String?
        let trackNumber: Int
        let type, uri: String

        enum CodingKeys: String, CodingKey {
            case artists
            case availableMarkets = "available_markets"
            case discNumber = "disc_number"
            case durationMS = "duration_ms"
            case explicit
            case externalUrls = "external_urls"
            case href, id
            case isLocal = "is_local"
            case name
            case previewURL = "preview_url"
            case trackNumber = "track_number"
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
    
    let items: [Item]
}

struct AlbumTracksEndpointResponse: Decodable {
    var tracks = [Track]()
    
    init(from decoder: Decoder) throws {
        let response = try AlbumTracksEndpointModel(from: decoder)
        
        for item in response.items {
            let trackName = item.name
            let trackId = item.id
            let trackDuration = item.durationMS.msToSeconds.minuteSecondMS
            let externalURL = URL(string: item.externalUrls.spotify)!
            
            var artists = ""
            for artist in item.artists {
                artists += "\(artist.name), "
            }
            artists.removeLast(2)
            
            let track = Track(name: trackName, id: trackId, duration: trackDuration, artists: artists, albumImage: nil, externalURL: externalURL)
            
            tracks.append(track)
        }
    }
}
