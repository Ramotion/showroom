import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let html_url: String
}

// MARK: Methods
extension User {
    
    var toDictionary: [String: Any] {
        return [
            "id": "\(id)",
            "name": name,
            "html_url": html_url
        ]
    }
}
