import Foundation

protocol TransformationsUseCaseProtocol  {
    var repo: TransformationsRepositoryProtocol { get }
    func getTransformations(filter: String) async -> [TransformationsEntity]
}

final class TransformationsUseCase: TransformationsUseCaseProtocol {
    var repo: any TransformationsRepositoryProtocol
    
    init(repo: TransformationsRepositoryProtocol = TransformationsRepository(network: NetworkHeros())){
        self.repo = repo
    }
    
    func getTransformations(filter: String) async -> [TransformationsEntity] {
        return await repo.getTransformationsForHero(heroID: filter)
        
    }

}



final class TransformationsUseCaseFake: TransformationsUseCaseProtocol {
    var repo: any TransformationsRepositoryProtocol
    
    init(repo: TransformationsRepositoryProtocol = TransformationsRepositoryFake()) {
        self.repo = repo
    }
    
    func getTransformations(filter: String) async -> [TransformationsEntity] {
        return await repo.getTransformationsForHero(heroID: filter)
        
    }

}
