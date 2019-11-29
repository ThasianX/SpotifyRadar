//
//  SessionService.swift
//  SpotifyDaily
//
//  Created by Kevin Li on 11/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import RxSwift

class SessionService {
    
    enum SessionError: Error {
        case invalidToken
    }
    
    // MARK: - Private fields
    
    private let dataManager: DataManager
    
    private let signOutSubject = PublishSubject<Void>()
    private let signInSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    private var token: Token?
    
    // MARK: - Public properties
    
    private(set) var sessionState: SessionModel?
    
    var didSignOut: Observable<Void> {
        return self.signOutSubject.asObservable()
    }
    var didSignIn: Observable<Void> {
        return self.signInSubject.asObservable()
    }
    
    // MARK: - Public Methods
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        
        self.configureSpotify()
        self.loadSession()
    }
    
    func signIn() -> Completable {
        
        return self.translationsService.fetchTranslations()
            .andThen(signIn)
            .do(onSuccess: { [weak self] in try self?.setToken(response: $0) })
            .flatMap { _ in fetchMe }
            .do(onSuccess: { [weak self] in try self?.setSession(credentials: credentials, response: $0) })
            .asCompletable()
    }
    
    func signOut() -> Completable {
        let signOut = self.restClient.request(SessionEndpoints.SignOut())
        
        return signOut
            .do(onSuccess: { [weak self] _ in self?.removeSession() })
            .asCompletable()
    }
    
    func refreshProfile() -> Single<MeResponse> {
        // Use access token to request profile data again and then set updateprofile
        let fetchMe = self.restClient.request(SessionEndpoints.FetchMe())
        
        return fetchMe
            .do(onSuccess: { [weak self] in self?.updateProfile(data: $0) })
    }
    
    // MARK: - Session Management
    
    private func configureSpotify(){
        let redirectURL: URL = URL(string: "spotify-daily-login://")!
        SpotifyLogin.shared.configure(clientID: "8cece41fa2cc49a48e66b70cbc7789fc",
                                      clientSecret: "89faaf509a5e49569abb3fc93ebe4740",
                                      redirectURL: redirectURL)
        
        Logger.info("Configured clientID, clientSecret, and redirectURL")
    }
    
    private func loadSession() {
//        SpotifyLogin.shared.getAccessToken { [weak self] (accessToken, error) in
//            guard let `self` = self else { return }
//
//            if error != nil, accessToken == nil {
//                self.showSignIn()
//            } else {
//                self.showDashBoard()
//            }
//        }
        self.sessionState = self.dataManager.get(key: SettingKey.session, type: SessionModel.self)
    }
    
    private func setToken(response: SignInResponse) throws {
        guard let accessToken = response.accessToken,
            let refreshToken = response.refreshToken,
            let expirationDate = response.expirationDate else {
            throw SessionError.invalidToken
        }
        
        self.token = Token(accessToken: accessToken, refreshToken: refreshToken, expirationDate: expirationDate)
    }
    
    private func setSession(response: UserModel) throws {
        guard let token = self.token else {
            throw SessionError.invalidToken
        }
        
        self.sessionState = SessionModel(token: token, user: response)
        self.dataManager.set(key: SettingKey.session, value: self.sessionState)
        
        self.signInSubject.onNext(Void())
    }
    
    private func removeSession() {
        self.dataManager.clear()
        self.token = nil
        self.sessionState = nil
        self.signOutSubject.onNext(Void())
    }
    
    private func updateProfile(user: UserModel) {
        self.sessionState?.updateDetails(user)
        self.dataManager.set(key: SettingKey.session, value: self.sessionState)
    }
}
