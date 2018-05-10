import Foundation
import KeychainAccess
import OAuthSwift

final class KeychainManager {
    
    private enum Key {
        static let server = "https://dribbble.com"
        static let token = "dribble-token"
    }
}

// MARK: Methods
extension KeychainManager {
    
    static func setKeychain(token: OAuth2Swift.DribbbleToken) {
        print("save token: \(token)")
        let keychain = Keychain(server: Key.server, protocolType: .https, authenticationType: .htmlForm)
        keychain[Key.token] = token
    }

    static func getKeychain() -> OAuth2Swift.DribbbleToken? {
        let keychain = Keychain(server: Key.server, protocolType: .https, authenticationType: .htmlForm)
        return keychain[Key.token]
    }
}
