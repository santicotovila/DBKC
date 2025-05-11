import Foundation

final class HerosRepository: HerosRepositoryProtocol {
    private var network: NetworkHerosProtocol
    
   init(network: NetworkHerosProtocol) {
        self.network = network
    }
    
    func getHeros(IDHeros: String) async -> [HerosEntity] {
        return await network.getHeros(filter: IDHeros)
    }
}

final class HerosRepositoryFake: HerosRepositoryProtocol {
    private var network: NetworkHerosProtocol
    
   init(network: NetworkHerosProtocol = NetworkHerosMock()) {
        self.network = network
    }
    
    func getHeros(IDHeros: String) async -> [HerosEntity] {
        return await network.getHeros(filter: IDHeros)
    }
}
