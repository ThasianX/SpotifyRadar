import Foundation

struct Session: Codable, Equatable {
    private(set) var token: Token
    private(set) var user: User
    
    mutating func updateSession(_ session: Session) {
        self.token = session.token
        self.user = session.user
    }
}
