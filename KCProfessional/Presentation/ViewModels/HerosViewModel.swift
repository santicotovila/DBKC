import Foundation
import Combine

final class HerosViewModel: ObservableObject {
    //Lista de heroes
    @Published var heros = [HerosEntity]()
    
    //Combine
    var suscriptors = Set<AnyCancellable>()
    private var useCaseHeros: HeroUseCaseProtocol
    
    init(useCaseHeros: HeroUseCaseProtocol = HeroUseCase()) {
        self.useCaseHeros = useCaseHeros
        Task{
            await loadHeros()
        }
    }
    
    func loadHeros() async {
        let data = await useCaseHeros.getHeros(filter: "")
        
        DispatchQueue.main.async {
            self.heros = data
        }
    }
}
