import Foundation

struct HerosEntity: Codable {
    let id: String
    let favorite: Bool
    let description: String
    let photo: String
    let name: String
}


//Filter the request od Heros by name
struct HeroModelRequest: Codable {
    let name: String
}

