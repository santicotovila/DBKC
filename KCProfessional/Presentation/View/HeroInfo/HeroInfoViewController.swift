import Foundation
import UIKit
import Combine

final class HeroInfoViewController: UIViewController {
    
    
    //MARK: - Outlets
    
    @IBOutlet private weak var imageHero: UIImageView!
    
    @IBOutlet private  weak var messageTransformationsEmpty: UILabel!
    
    @IBOutlet private  weak var descriptionHero: UITextView!
    
    
    @IBOutlet private weak var transformationsButton: UIButton!
    
    
    //MARK: - Instancies
    
    private var viewModel: HeroInfoViewModel
    private var transformationsVM  = TransformationsViewModel()
    
    var suscriptors = Set<AnyCancellable>()
    
    
    init(viewModel:HeroInfoViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: "HeroInfoView", bundle: nil)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        //loadData()
        
    }
    
    
    /* private func loadData() {
     
     Task {
     await transformationsVM.loadTransformations()
     }
     
     }
    */
    //MARK: - Configure Outlets
    
    private func configureUI() {
        
        viewModel.$selectedHero
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] hero in
                guard let heroSelected = hero else {return}
                guard let url = URL(string: heroSelected.photo) else {return}
                self?.imageHero.loadImageRemote(url: url)
                self?.descriptionHero.text = heroSelected.description
                self?.messageTransformationsEmpty.text = "There are no transformations"
            }
            .store(in: &suscriptors)
        
        /*
         transformationsVM.$transformations
         .receive(on: DispatchQueue.main)
         .sink{ [weak self] transformations in
         if transformations.isEmpty {
         self?.transformationsButton.isHidden = true
         }
         else {
         self?.transformationsButton.isHidden = false
         }
         
         } .store(in: &suscriptors)*/
        
        
        //🔎 FIXME: - He tenido problemas para gestinar el boton segun este habilitado o no usando combine,creo que la idea esta bien pero no soy capaz de llevarla acabo,intente hacer la carga de heroes en el ciclo de vida para que cargue con antelacion pero si la ejecuto alli automaticamente siempre estan cargados y nunca va ser vacio ,entonces la deje en la logica del boton pero me queda sin resolverlo el ocultar el boton o no dependiendo de si tiene transformaciones(se que no era necesario pero te agradeceria que me ayudaras a solucionarlo porque me agobió un poco el problema del boton😅
    }
    /*
    private func buttonVisibility() {
        
        let viewController = TransformationsBuilder.build(heroInfoVM: self.viewModel)
        Task {
            await viewController.viewModel.loadTransformations()
        }
        
        let instancie = viewController.viewModel.transformations
        if instancie.isEmpty {
            self.transformationsButton.isHidden = true
        }
        else {
            self.transformationsButton.isHidden = false
        }
    }
    */
    
    // Access Transformations
    @IBAction func tapAccessTransformation() {
        
              let vc = TransformationsBuilder.build(heroInfoVM: self.viewModel)
             self.navigationController?.present(vc, animated: true)
         Task {
             await vc.viewModel.loadTransformations()
         }
        /*
         if transformationsVM.transformations.isEmpty {
         let vcEmpty = TransformationEmptyViewController()
         self.navigationController?.present(vcEmpty, animated: true)
         
         }
         else {
         let vc = TransformationsBuilder.build(heroInfoVM: self.viewModel)
         self.navigationController?.present(vc, animated: true)
         }*/
            }
    //🔎 FIXME: - Tambien he probado todo  esto que deje comentado pero he tenido problemas con la carga, creo que porque no llega a cargar a tiempo  pero llevarla al hilo principal tampoco creo que sea lo adecuado,he probado con el @mainActor explicado en clase en loadTransformations pero tampoco funciono y ya no se que mas probar😅 deberia haber creado un collection view en este mismo viewcontroller y me evitaba tanta complciacion...pero ahora me quedó la curiosidad😅
        
    }

