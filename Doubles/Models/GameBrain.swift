//
//  GameBrain.swift
//  Doubles
//
//  Created by Svetlana Kirillova on 02.06.2023.
//

import Foundation

struct GameBrain {
    
    let fieldHeight: Int
    let fieldWidth: Int
    var battleField: [[GameCell?]] = []
    var score: Int = 0
    let colors = [
        K.Colors.blue,
        K.Colors.gray,
        K.Colors.green,
        K.Colors.pink,
        K.Colors.purple,
        K.Colors.red,
        K.Colors.yellow
    ]
    
    init(fieldHeight: Int, fieldWidth: Int) {

        self.fieldHeight = fieldHeight
        self.fieldWidth = fieldWidth
        battleField = Array(repeating: Array(repeating: nil , count: fieldWidth ), count: fieldHeight )
        
        fullFillBattleField()
        for color in colors {
            fillRandomly(with: color, inQuantity: 20)
        }
//        fillRandomly(with: 1, inQuantity: 20)
//        fillRandomly(with: 2, inQuantity: 20)
//        fillRandomly(with: 3, inQuantity: 20)
//        fillRandomly(with: 4, inQuantity: 20)
//        fillRandomly(with: 5, inQuantity: 20)
//        fillRandomly(with: 6, inQuantity: 20)
//        fillRandomly(with: 7, inQuantity: 20)
    }
    
    
    mutating func fullFillBattleField(){
        
        for y in 0...(fieldHeight - 1 ){
            for x in 0...(fieldWidth - 1) {
                
                let cell = GameCell(x: x, y: y, value: "")
                battleField[y][x] = cell
            }
        }
    }
    
    mutating func fillRandomly(with value: String, inQuantity qnt: Int){
        
        for _ in 1...qnt {
            
            while true {
                let randomX = Int.random(in: 0...( fieldWidth - 1))
                let randomY = Int.random(in: 0...(fieldHeight - 1))
                
                if battleField[randomY][randomX]?.value == "" {
                    
                    battleField[randomY][randomX]?.value = value
                    break
                }
                
            }
            
        }
    }
    
    
    func findIntersections(at point: GameCell) -> [GameCell?] {
        
        var crossPoints = [GameCell?]()
//        var pointA, pointB, pointC, pointD: GameCell?

        var x = point.x-1
        
        while x >= 0 {
            
            if battleField[point.y][x]?.value != "" {
                crossPoints.append(battleField[point.y][x])
                break
            }
            x -= 1
        }
        x = point.x+1
        
        while x <= fieldWidth - 1 {
            
            if battleField[point.y][x]?.value != "" {
                crossPoints.append(battleField[point.y][x])
                break
            }
            x += 1
        }
        
        var y = point.y - 1
        
        while y >= 0 {
            
            if battleField[y][point.x]?.value != "" {
                crossPoints.append(battleField[y][point.x])
                break
            }
            y -= 1
        }
        
        y = point.y + 1
        
        while y <= fieldHeight - 1 {
            
            if battleField[y][point.x]?.value != "" {
                crossPoints.append(battleField[y][point.x])
                break
            }
            y += 1
        }

        
        print("Cross point are : \(crossPoints)")
        
        var sameValues = [GameCell?]()
        var sameValuesCount = 0
        
        print("Start to find equal points for matching...")
        for p0 in crossPoints {
            
            print("Checking point - \(p0)")
            sameValues.append(p0)
            sameValuesCount = sameValues.count
            
            sameValues.append(
                contentsOf:
                    crossPoints.filter { cell in
                        if cell?.value == p0?.value && !(cell?.x == p0?.x && cell?.y == p0?.y) {
                            print("Point \(cell!) has the same values as \(p0!)")
                            return true
                        }
                        return false
                    }
            )

            if sameValuesCount == sameValues.count {
                print("There are not points equal to point \(p0!)")
                sameValues.removeLast()
            } else {
                print("We found matching points \(sameValues)")
                crossPoints.removeAll { gameCell in
                    if gameCell?.value == p0?.value {
                        return true
                    }
                    return false
                }
            }

        }
        
        if sameValues.count>0 {
            print("Equal cells: \(sameValues)")
            
        }
        
        return sameValues
            
    }
    
    
}
