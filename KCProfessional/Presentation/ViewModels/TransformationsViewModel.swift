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
    
   
    func loadTransformations() async {
        guard let heroID = heroInfoVM.selectedHero?.id else { return }
        let data = await useCaseTransformations.getTransformations(filter: heroID)
        print("datos son \(data.count)")
        DispatchQueue.main.async {
            self.transformations = data
        }
    }
    

}
