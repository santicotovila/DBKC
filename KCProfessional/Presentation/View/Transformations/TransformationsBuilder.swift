
import Foundation

//FIXME: - 🔎 Es buena práctica crear un builder aqui?aunque no lo haya creado en el resto de la app?ya que aqui si que vi la necesidad para inicializar todo.
final class TransformationsBuilder {
        static func build(heroInfoVM: HeroInfoViewModel) -> TransformationsTableViewController {
        let useCase = TransformationsUseCase()
        let viewModel = TransformationsViewModel(heroInfoVM: heroInfoVM, useCaseTransformations: useCase)
        let vc = TransformationsTableViewController(viewModel: viewModel)
        return vc
    }
}


