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
        DispatchQueue.main.async {
            self.transformations = data
        }
    }

}


