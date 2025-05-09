import Foundation

final class TransformationsRepository: TransformationsRepositoryProtocol {
   
    
    
    private var network: NetworkHerosProtocol
    
    init(network: NetworkHerosProtocol) {
        self.network = network
    }
    
    func getTransformationsForHero(heroID: String) async -> [TransformationsEntity] {
        return await network.getTransformationsAPI(heroID: heroID)
    }
    

    
    
}

final class TransformationsRepositoryFake: TransformationsRepositoryProtocol {
    
    
    private var network: NetworkHerosProtocol
    
    
    init(network: NetworkHerosProtocol = NetworkHerosMock()) {
        self.network = network
    }
    
    func getTransformationsForHero(heroID filter: String) async -> [TransformationsEntity] {
        return await network.getTransformationsAPI(heroID: filter)
    }
    
    
}

