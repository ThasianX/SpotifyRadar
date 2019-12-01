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
    
    // MARK: - Private fields
    
    private let dataManager: DataManager
    private let networkingClient: Networking
    
    private let signOutSubject = PublishSubject<Void>()
    private let signInSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    private(set) var sessionState: Session?
    private var token: Token?
    
    var didSignOut: Observable<Void> {
        return self.signOutSubject.asObservable()
    }
    var didSignIn: Observable<Void> {
        return self.signInSubject.asObservable()
    }
    
    // MARK: - Public Methods
    
    init(dataManager: DataManager, networkingClient: Networking) {
        self.dataManager = dataManager
        self.networkingClient = networkingClient
        
        self.loadSession()
    }
    
    func signIn(response: SignInResponse) {
        //first set token, then call function to get user, then set session
        
        self.setToken(response: response)
        
        networkingClient.userProfileRequest(accessToken: self.token?.accessToken)
            .bind(onNext: { [weak self] in
                self?.setSession(profileResponse: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func signOut() {
        self.removeSession()
    }
    
    func refreshProfile() {
        // Use access token to request profile data again and then set updateprofile
        let response = networkingClient.userProfileRequest(accessToken: self.token?.accessToken)
        
//        if let user = response {
//            self.updateProfile(user: user)
//        } else {
//            Logger.error("Unable to refresh user profile")
//        }
        
        //        return Single.just(user).do(onSuccess: { [weak self] in self?.updateProfile(user: $0) })
    }
    
    // MARK: - Session Management
    private func loadSession() {
        self.sessionState = self.dataManager.get(key: SettingKey.session, type: Session.self)
    }
    
    func setToken(response: SignInResponse) {
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
        
        let user = User(country: profileResponse.country,
                        displayName: profileResponse.displayName,
                        email: profileResponse.email,
                        filterEnabled: profileResponse.filterEnabled,
                        profileUrl: profileResponse.profileUrl,
                        numberOfFollowers: profileResponse.numberOfFollowers,
                        endpointUrl: profileResponse.endpointUrl,
                        id: profileResponse.id,
                        avatarUrl: profileResponse.avatarUrl,
                        subscriptionLevel: profileResponse.subscriptionLevel,
                        uriUrl: profileResponse.uriUrl)
        
        self.sessionState = Session(token: token, user: user)
        self.dataManager.set(key: SettingKey.session, value: self.sessionState)
        
        self.signInSubject.onNext(Void())
    }
    
    private func removeSession() {
        self.dataManager.clear()
        self.token = nil
        self.sessionState = nil
        self.signOutSubject.onNext(Void())
    }
    
    private func updateProfile(user: User) {
        self.sessionState?.updateDetails(user)
        self.dataManager.set(key: SettingKey.session, value: self.sessionState)
    }
}
