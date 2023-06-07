//
//  GameCell.swift
//  Doubles
//
//  Created by Svetlana Kirillova on 02.06.2023.
//

import Foundation

struct GameCell {
    
    let x: Int
    let y: Int

    var value: String?

    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        
    }
    init(x: Int, y: Int, value: String) {
        self.x = x
        self.y = y
        self.value = value
        
    }
    

}
