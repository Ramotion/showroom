import Foundation

struct FirebaseModel {
}

extension FirebaseModel {
    
    struct Shot: Codable {
        let title: String
        let html_url: String
        let id: Int
        let userId: Int
    }
}
