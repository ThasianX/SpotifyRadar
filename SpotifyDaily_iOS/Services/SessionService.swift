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
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        
        self.loadSession()
    }
    
    func signIn(response: SignInResponse) {
        //first set token, then call function to get user, then set session
        
        do {
            try self.setToken(response: response)
            
            let response = Networking.userProfileRequest(accessToken: self.token?.accessToken)
            
            if let user = response {
                try self.setSession(user: user)
            } else {
                Logger.error("Unable to set session for user")
            }
            
        } catch {
            Logger.error("Error while signing in: \(error).")
        }
        
        
        
//        return self.translationsService.fetchTranslations()
//            .andThen(signIn)
//            .do(onSuccess: { [weak self] in try self?.setToken(response: $0) })
//            .flatMap { _ in fetchMe }
//            .do(onSuccess: { [weak self] in try self?.setSession(credentials: credentials, response: $0) })
//            .asCompletable()
    }
    
    func signOut() {
        self.removeSession()
    }
    
    func refreshProfile() {
        // Use access token to request profile data again and then set updateprofile
        let response = Networking.userProfileRequest(accessToken: self.token?.accessToken)
        
        if let user = response {
            self.updateProfile(user: user)
        } else {
            Logger.error("Unable to refresh user profile")
        }
        
//        return Single.just(user).do(onSuccess: { [weak self] in self?.updateProfile(user: $0) })
    }
    
    // MARK: - Session Management
    private func loadSession() {
        self.sessionState = self.dataManager.get(key: SettingKey.session, type: Session.self)
    }
    
    func setToken(response: SignInResponse) throws {
        guard let accessToken = response.accessToken,
            let refreshToken = response.refreshToken,
            let expirationDate = response.expirationDate else {
            throw SessionError.invalidToken
        }
        
        self.token = Token(accessToken: accessToken, refreshToken: refreshToken, expirationDate: expirationDate)
    }
    
    private func setSession(user: User) throws {
        guard let token = self.token else {
            throw SessionError.invalidToken
        }
        
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
