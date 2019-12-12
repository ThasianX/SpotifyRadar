//
//  SessionService.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SessionService {
    
    enum SessionError: Error {
        case invalidToken
    }
    
    // MARK: - Properties
    // MARK: Dependencies
    private let dataManager: DataManager
    private let networkingClient: Networking
    private let configuration: Configuration
    
    // MARK: Private fields
    private let signOutSubject = PublishSubject<Void>()
    private let signInSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    private(set) var sessionState: Session?
    private var token: Token?
    
    // MARK: Public fields
    var didSignOut: Observable<Void> {
        return self.signOutSubject.asObservable()
    }
    var didSignIn: Observable<Void> {
        return self.signInSubject.asObservable()
    }
    
    // MARK: - Initialization
    init(dataManager: DataManager, networkingClient: Networking, configuration: Configuration) {
        self.dataManager = dataManager
        self.networkingClient = networkingClient
        self.configuration = configuration
        
        self.loadSession()
    }
    
    private func loadSession() {
        self.sessionState = dataManager.get(key: DataKeys.session, type: Session.self)
        self.token = sessionState?.token
        
        checkIfTokenValid()
    }
    
    // MARK: - Public methods
    // MARK: Token State
    func checkIfTokenValid(){
        if self.token != nil && !self.token!.isValid() {
            self.networkingClient.renewSession(session: sessionState, clientID: configuration.clientID, clientSecret: configuration.clientSecret)
                .bind(onNext: { [unowned self] session in
                    self.updateSession(session: session)
                })
            .disposed(by: disposeBag)
        }
    }
    
    // MARK: Sign In State
    func signIn(response: SignInResponse) {
        self.setToken(response: response)
        
        networkingClient.userProfileRequest(accessToken: self.token?.accessToken)
            .bind(onNext: { [weak self] in
                self?.setSession(profileResponse: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func signOut() {
        self.dataManager.clear()
        self.token = nil
        self.sessionState = nil
        self.signOutSubject.onNext(Void())
    }
    
    // MARK: Networking methods
    func getUserProfile() -> Observable<User> {
        return networkingClient.userProfileRequest(accessToken: self.token?.accessToken)
            .flatMap { response -> Observable<User> in
                let user = User(country: response.country, displayName: response.displayName, email: response.email, filterEnabled: response.filterEnabled, profileUrl: response.profileUrl, numberOfFollowers: response.numberOfFollowers, endpointUrl: response.endpointUrl, id: response.id, avatarUrl: response.avatarUrl, subscriptionLevel: response.subscriptionLevel, uriUrl: response.uriUrl)
                return Observable.just(user)
        }
    }
    
    func getTopArtists(timeRange: String, limit: Int) -> Observable<[Artist]>{
        return networkingClient.userTopArtistsRequest(accessToken: self.token?.accessToken, timeRange: timeRange, limit: limit)
            .flatMap { response -> Observable<[Artist]> in
                let artists = response.artists
                return Observable.just(artists)
        }
    }
    
    func getTopTracks(timeRange: String, limit: Int) -> Observable<[Track]>{
        return networkingClient.userTopTracksRequest(accessToken: self.token?.accessToken, timeRange: timeRange, limit: limit)
            .flatMap { response -> Observable<[Track]> in
                let tracks = response.tracks
                return Observable.just(tracks)
        }
    }
    
    func getRecentlyPlayedTracks(limit: Int) -> Observable<[RecentlyPlayedTrack]>{
        return networkingClient.userRecentlyPlayedRequest(accessToken: self.token?.accessToken, limit: limit)
            .flatMap { response -> Observable<[RecentlyPlayedTrack]> in
                let tracks = response.tracks
                return Observable.just(tracks)
        }
    }
    
    func getArtist(href: URL) -> Observable<Artist> {
        return networkingClient.artistRequest(accessToken: self.token?.accessToken, artistURL: href)
            .flatMap { response -> Observable<Artist> in
                let artist = response.artist
                return Observable.just(artist!)
        }
    }
    
    // MARK: - Private Session Management Methods
    private func setToken(response: SignInResponse) {
        guard let accessToken = response.accessToken,
            let refreshToken = response.refreshToken,
            let expirationDate = response.expirationDate else {
                fatalError("Unable to set invalid token")
        }
        
        self.token = Token(accessToken: accessToken, refreshToken: refreshToken, expirationDate: expirationDate)
    }
    
    private func setSession(profileResponse: ProfileEndpointResponse) {
        guard let token = self.token else {
            fatalError("Unable to create session due to invalid token")
        }
        sessionState = Session(token: token, userId: Int(profileResponse.id)!)
        dataManager.set(key: DataKeys.session, value: self.sessionState)
        setDefaultData()
        signInSubject.onNext(Void())
    }
    
    private func updateSession(session: Session) {
        self.sessionState?.updateSession(session)
        self.token = session.token
        self.dataManager.set(key: DataKeys.session, value: self.sessionState)
    }
    
    private func setDefaultData() {
        let topArtistsState = TopArtistsViewControllerState(artistsTimeRange:
            "medium_term", artistsLimit: 10)
        self.dataManager.set(key: DataKeys.topArtistsCollectionState, value: topArtistsState)
        
        let topTracksState = TopTracksViewControllerState(tracksTimeRange:
            "medium_term", tracksLimit: 10)
        self.dataManager.set(key: DataKeys.topTracksCollectionState, value: topTracksState)
    }
}
