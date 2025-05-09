import Foundation

protocol HeroUseCaseProtocol {
    var repo:  HerosRepositoryProtocol { get set }
    func getHeros(filter: String) async -> [HerosEntity]
}

final class HeroUseCase: HeroUseCaseProtocol {
    var repo: HerosRepositoryProtocol
    
    init(repo: HerosRepositoryProtocol = HerosRepository(network: NetworkHeros())) {
        self.repo = repo
    }
    
    func getHeros(filter: String) async -> [HerosEntity] {
        return await repo.getHeros(IDHeros: filter)
    }
}

final class FakeHeroUseCase: HeroUseCaseProtocol {
    var repo: HerosRepositoryProtocol
    
    init(repo: HerosRepositoryProtocol = HerosRepositoryFake()) {
        self.repo = repo
    }
    
    func getHeros(filter: String) async -> [HerosEntity] {
        
        return await repo.getHeros(IDHeros: filter)
    }
}
