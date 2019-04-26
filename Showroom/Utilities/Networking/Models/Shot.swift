import Foundation

struct Shot: Codable {
    let id: Int
    let description: String?
    let html_url: String
    let title: String
    let images: Images
    let animated: Bool
    
    struct Images: Codable {
        let normal: String
        let hidpi: String?
    }
    
    var imageUrl: URL? {
        return URL(string: images.normal)
    }
}

// MARK: Methods
extension Shot {
    
    var toDictionary: [String: Any] {
        return [
            "id": id,
            "title": title,
            "html_url": html_url,
            "date": Date().timeIntervalSince1970,
        ]
    }
}
