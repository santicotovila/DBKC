//
//  HerosTableViewCell.swift
//  KCProfessional
//
//  Created by Santiago Coto Vila on 04/05/2025.
//

import UIKit

class HerosTableViewCell: UITableViewCell {

   
    //MARK: - Outlets
    
    @IBOutlet private weak var imageHero: UIImageView!
    
    @IBOutlet private weak var nameHero: UILabel!
    
    
    func configure(with hero: HerosEntity) {
        
        guard let imageUrl = URL(string: hero.photo) else {return}
        imageHero.loadImageRemote(url: imageUrl)
        nameHero.text = hero.name
        
    }

}
