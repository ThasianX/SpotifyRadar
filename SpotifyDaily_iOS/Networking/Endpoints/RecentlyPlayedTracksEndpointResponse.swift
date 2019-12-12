//
//  RecentlyPlayedTracksEndpointResponse.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 12/8/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

fileprivate struct RecentlyPlayedTracksEndpointModel: Decodable {
    // MARK: - Cursors
    struct Cursors: Codable {
        let after, before: String
    }

    // MARK: - Item
    struct Item: Codable {
        let track: Track
        let playedAt: String
        let context: Context

        enum CodingKeys: String, CodingKey {
            case track
            case playedAt = "played_at"
            case context
        }
    }

    // MARK: - Context
    struct Context: Codable {
        let externalUrls: ExternalUrls
        let href: String
        let type, uri: String

        enum CodingKeys: String, CodingKey {
            case externalUrls = "external_urls"
            case href, type, uri
        }
    }

    // MARK: - ExternalUrls
    struct ExternalUrls: Codable {
        let spotify: String
    }

    // MARK: - Track
    struct Track: Codable {
        let album: Album
        let artists: [Artist]
        let availableMarkets: [String]
        let discNumber, durationMS: Int
        let explicit: Bool
        let externalUrls: ExternalUrls
        let href: String
        let id: String
        let isLocal: Bool
        let name: String
        let popularity: Int
        let previewURL: String
        let trackNumber: Int
        let type, uri: String

        enum CodingKeys: String, CodingKey {
            case album, artists
            case availableMarkets = "available_markets"
            case discNumber = "disc_number"
            case durationMS = "duration_ms"
            case explicit
            case externalUrls = "external_urls"
            case href, id
            case isLocal = "is_local"
            case name, popularity
            case previewURL = "preview_url"
            case trackNumber = "track_number"
            case type, uri
        }
    }

    // MARK: - Album
    struct Album: Codable {
        let albumType: String
        let artists: [Artist]
        let availableMarkets: [String]
        let externalUrls: ExternalUrls
        let href: String
        let id: String
        let images: [Image]
        let name, releaseDate, releaseDatePrecision: String
        let totalTracks: Int
        let type, uri: String

        enum CodingKeys: String, CodingKey {
            case albumType = "album_type"
            case artists
            case availableMarkets = "available_markets"
            case externalUrls = "external_urls"
            case href, id, images, name
            case releaseDate = "release_date"
            case releaseDatePrecision = "release_date_precision"
            case totalTracks = "total_tracks"
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

    // MARK: - Image
    struct Image: Codable {
        let height: Int
        let url: String
        let width: Int
    }
    
    let items: [Item]
    let next: String
    let cursors: Cursors
    let limit: Int
    let href: String
}

struct RecentlyPlayedTracksEndpointResponse: Decodable {
    var tracks = [RecentlyPlayedTrack]()
    
    init(from decoder: Decoder) throws {
        let response = try RecentlyPlayedTracksEndpointModel(from: decoder)
        
        for item in response.items {
            let trackName = item.track.name
            let albumName = item.track.album.name
            
            let artists = item.track.artists
            var artistEndpoints = [URL]()
            for artist in artists {
                artistEndpoints.append(URL(string: artist.href)!)
            }
            
            let trackDuration = item.track.durationMS.msToSeconds.minuteSecondMS
            let playedFrom = "\(item.context.type)".capitalizingFirstLetter()
            
            let playedAtISO = item.playedAt
            let date = playedAtISO.iso8601
            let playedAt = date!.mediumStyle
            
            let externalURL = URL(string: item.track.externalUrls.spotify)!
            
            let track = RecentlyPlayedTrack(trackName: trackName, albumName: albumName, artistURLs: artistEndpoints, duration: trackDuration, playedFrom: playedFrom, playedAt: playedAt, externalURL: externalURL)
            
            tracks.append(track)
        }
    }
}
