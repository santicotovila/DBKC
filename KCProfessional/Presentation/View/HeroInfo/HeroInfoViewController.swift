import Foundation
import UIKit
import Combine

final class HeroInfoViewController: UIViewController {
    
    
    //MARK: - Outlets
    
    @IBOutlet private weak var imageHero: UIImageView!
    
    @IBOutlet private  weak var messageTransformationsEmpty: UILabel!
    
    @IBOutlet private  weak var descriptionHero: UITextView!
    
    //MARK: - Instancies
    
     private var viewModel: HeroInfoViewModel
    
    
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
       
    }
    
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
        
     /*   viewModel.$selectedHero
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transformation in
                
                
            }*/
                
}
    
    // Access Transformations
        
     @IBAction func tapAccessTransformation() {
        
         let vc = TransformationsBuilder.build(heroInfoVM: self.viewModel)
         self.navigationController?.present(vc, animated: true)
         Task {
                await vc.viewModel.loadTransformations()
                }
    }
}

