import Foundation

struct TransformationsEntiti: Codable {
    let photo: String
    let description: String
    let id: String
    let name: String
}

struct TransformationsRequest: Codable {
    let id: String
}
