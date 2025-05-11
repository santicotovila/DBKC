import Foundation
import Combine

final class TransformationsViewModel: ObservableObject {
    @Published var transformations = [TransformationsEntity]()
    
    let heroInfoVM : HeroInfoViewModel
    private var useCaseTransformations: TransformationsUseCaseProtocol
    
    init(heroInfoVM:HeroInfoViewModel = HeroInfoViewModel(),useCaseTransformations: TransformationsUseCaseProtocol = TransformationsUseCase()) {
        self.heroInfoVM = heroInfoVM
        self.useCaseTransformations = useCaseTransformations
    }
    
    //@MainActor
    func loadTransformations() async {
        guard let heroID = heroInfoVM.selectedHero?.id else { return }
        let data = await useCaseTransformations.getTransformations(filter: heroID)
        print("datos son \(data.count)")
        DispatchQueue.main.async {
            self.transformations = data
        }
    }

}


final class MockTransformationsViewModel: ObservableObject {
    @Published var transformations = [TransformationsEntity]()
    
    let heroInfoVM : MockHeroInfoViewModel
    private var useCaseTransformations: TransformationsUseCaseFake
    
    init(heroInfoVM:MockHeroInfoViewModel = MockHeroInfoViewModel(),useCaseTransformations: TransformationsUseCaseProtocol = TransformationsUseCaseFake()) {
        self.heroInfoVM = heroInfoVM
        self.useCaseTransformations = useCaseTransformations as! TransformationsUseCaseFake
    }
}
