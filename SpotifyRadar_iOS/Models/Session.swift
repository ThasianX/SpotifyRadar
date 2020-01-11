import Foundation

struct Session: Codable, Equatable {
    private(set) var token: Token
    private(set) var userId: String
    
    mutating func updateSession(_ session: Session) {
        self.token = session.token
        self.userId = session.userId
    }
}
