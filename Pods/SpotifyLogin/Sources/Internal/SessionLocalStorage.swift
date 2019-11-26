// Copyright (c) 2017 Spotify AB.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

internal class SessionLocalStorage {

    internal class func save(session: Session?) {
        guard let session = session else {
            return
        }

        do {
            let encodedSession = try PropertyListEncoder().encode(session)
            if !KeychainWrapper.save(encodedSession, forKey: session.username) {
                // handle error
            }
            storeUsername(session.username)
        } catch {}
    }

    internal class func loadSession() -> Session? {
        guard let userName = storedUsername() else {
            return nil
        }

        if let data = KeychainWrapper.data(forKey: userName) {
            let decodedSession = try? PropertyListDecoder().decode(Session.self, from: data)
            return decodedSession
        }

        return nil
    }

    internal class func removeSession() {
        if let userName = storedUsername() {
            if !KeychainWrapper.removeData(forKey: userName) {
                // handle error
            }
        }
        UserDefaults.standard.removeObject(forKey: Constants.KeychainUsernameKey)
    }

    // MARK: - Private
    private class func storeUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: Constants.KeychainUsernameKey)
    }

    private class func storedUsername() -> String? {
        return UserDefaults.standard.value(forKey: Constants.KeychainUsernameKey) as? String
    }
}

import Security

// Arguments for the keychain queries
private let kSecClassValue = String(kSecClass)
private let kSecAttrAccountValue = String(kSecAttrAccount)
private let kSecValueDataValue = String(kSecValueData)
private let kSecClassGenericPasswordValue = String(kSecClassGenericPassword)
private let kSecAttrServiceValue = String(kSecAttrService)
private let kSecMatchLimitValue = String(kSecMatchLimit)
private let kSecReturnDataValue = String(kSecReturnData)
private let kSecMatchLimitOneValue = String(kSecMatchLimitOne)

private let keychainServiceValue = Constants.KeychainServiceValue

internal class KeychainWrapper {

    class func save(_ data: Data, forKey key: String) -> Bool {
        let keychainQuery: [String: Any] = [kSecClassValue: kSecClassGenericPasswordValue,
                                            kSecAttrServiceValue: keychainServiceValue,
                                            kSecAttrAccountValue: key,
                                            kSecValueDataValue: data]
        SecItemDelete(keychainQuery as CFDictionary)
        let status: OSStatus = SecItemAdd(keychainQuery as CFDictionary, nil)
        return (status == errSecSuccess)
    }

    class func data(forKey key: String) -> Data? {
        let keychainQuery: [String: Any] = [kSecClassValue: kSecClassGenericPasswordValue,
                                            kSecAttrServiceValue: keychainServiceValue,
                                            kSecAttrAccountValue: key,
                                            kSecReturnDataValue: kCFBooleanTrue,
                                            kSecMatchLimitValue: kSecMatchLimitOneValue]

        var dataBuffer: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery as CFDictionary, &dataBuffer)
        if status == errSecSuccess {
            return dataBuffer as? Data
        }
        return nil
    }

    class func removeData(forKey key: String) -> Bool {
        let keychainQuery: [String: Any] = [kSecClassValue: kSecClassGenericPasswordValue,
                                            kSecAttrServiceValue: keychainServiceValue,
                                            kSecAttrAccountValue: key]
        let status: OSStatus = SecItemDelete(keychainQuery as CFDictionary)
        return (status == errSecSuccess)
    }
}
