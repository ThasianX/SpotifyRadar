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
    private let configuration: Configuration
    
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
    
    init(dataManager: DataManager, networkingClient: Networking, configuration: Configuration) {
        self.dataManager = dataManager
        self.networkingClient = networkingClient
        self.configuration = configuration
        
        self.loadSession()
    }
    
    private func loadSession() {
        self.sessionState = self.dataManager.get(key: SettingKey.session, type: Session.self)
        self.token = self.sessionState?.token
        
        checkIfTokenValid()
    }
    
    private func checkIfTokenValid(){
        if self.token != nil && !self.token!.isValid() {
            self.networkingClient.renewSession(session: sessionState, clientID: configuration.clientID, clientSecret: configuration.clientSecret) { [weak self] session, error in
                if let session = session, error == nil {
                    self?.updateSession(session: session)
                }
            }
        }
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
        self.dataManager.clear()
        self.token = nil
        self.sessionState = nil
        self.signOutSubject.onNext(Void())
    }
    
    func refreshProfile() {
        // Use access token to request profile data again and then set updateprofile
        
        networkingClient.userProfileRequest(accessToken: self.token?.accessToken)
            .flatMap { [unowned self] response -> Observable<User> in
                return self.getUserFromEndpoint(profileResponse: response)
            }
            .bind(onNext: { [unowned self] in
                let session = Session(token: self.sessionState!.token, user: $0)
                self.updateSession(session: session)
            })
            .disposed(by: disposeBag)
    }
    
    private func getUserFromEndpoint(profileResponse: ProfileEndpointResponse) -> Observable<User> {
        
        return Observable<User>.create { observer in
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
            
            observer.onNext(user)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    // MARK: - Session Management
    
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
        
        self.getUserFromEndpoint(profileResponse: profileResponse)
            .bind(onNext: { [weak self] in
                self?.sessionState = Session(token: token, user: $0)
                self?.dataManager.set(key: SettingKey.session, value: self?.sessionState)
                self?.signInSubject.onNext(Void())
            })
            .disposed(by: disposeBag)
    }
    
    private func updateSession(session: Session) {
        self.sessionState?.updateSession(session)
        self.token = session.token
        self.dataManager.set(key: SettingKey.session, value: self.sessionState)
    }
}
