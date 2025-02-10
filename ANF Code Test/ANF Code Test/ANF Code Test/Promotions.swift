import Foundation

struct Promotion: Codable {
    let title: String
    let backgroundImage: String
    let content: [Content]?
    let promoMessage, topDescription, bottomDescription: String?
}

// MARK: - Content
struct Content: Codable {
    let target: String
    let title: String
}
