import Foundation
import UIKit

final class TransformationsTableViewCell: UITableViewCell {
    
    
    //MARK: - Outlets
    
    @IBOutlet private weak var imageHero: UIImageView!
    
    @IBOutlet private weak var nameHero: UILabel!
    
    
    func configUI(with hero: TransformationsEntity?) {
        guard let hero = hero else {return}
        guard let imageURL = URL(string: hero.photo ?? "Empty") else {return}
        imageHero.loadImageRemote(url: imageURL)
        nameHero.text = hero.name
        
    }
         
    
}
