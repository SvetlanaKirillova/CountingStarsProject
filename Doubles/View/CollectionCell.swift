//
//  CollectionCell.swift
//  Doubles
//
//  Created by Svetlana Kirillova on 04.06.2023.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    
    override var isSelected: Bool {
        didSet {
            
            updateBackgroundColor()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        image.isHidden = false
    }
    
    func updateBackgroundColor(){
        if isSelected {
            self.backgroundColor = UIColor(named: K.Colors.selectedCellColor)
        } else {
            self.backgroundColor = UIColor(named: K.Colors.cellColor)
        }
        
    }
    
}
