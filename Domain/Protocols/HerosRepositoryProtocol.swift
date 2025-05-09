import Foundation

protocol HerosRepositoryProtocol {
    func getHeros(IDHeros: String) async -> [HerosEntity]
}
