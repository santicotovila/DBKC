
import Foundation

protocol TransformationsRepositoryProtocol {
    func getTransformationsForHero(heroID: String) async -> [TransformationsEntity]
}


