//
//  ViewController.swift
//  Doubles
//
//  Created by Svetlana Kirillova on 02.06.2023.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    
    let height = 16
    let width = 12
    var cellEdge = 0.0

    var game1: GameBrain?
    
    let reuseIdentifier = "cell"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.navigationController!.navigationBar.barStyle = .black
        
//        game1 = GameBrain(fieldHeight: height, fieldWidth: width)
//        print("Screen size - \(view.frame.size)")
//        cellEdge = view.frame.width/Double(width)
//        print(cellEdge)
        
        startNewGame()
    }

    func startNewGame(){

        game1 = GameBrain(fieldHeight: height, fieldWidth: width)

        collectionView.reloadData()
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return height
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return width
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        cellEdge = view.frame.width/Double(width)
         return CGSize(width: cellEdge, height: cellEdge)
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let y = indexPath.section
        let x = indexPath.row


        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionCell

        cell.layer.borderWidth = 0.2
        cell.layer.borderColor = UIColor(named: K.Colors.selectedCellColor)?.cgColor
        if let cellValue = game1?.battleField[y][x]?.value {
            if cellValue != "" {
                cell.image.tintColor = UIColor(named: cellValue)
            } else {
                cell.image.isHidden = true
            }
        }
        
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if game1?.battleField[indexPath.section][indexPath.row]?.value != "" {

            collectionView.deselectItem(at: indexPath, animated: true)

            return
        }
        
        let pressedCell = game1?.battleField[indexPath.section][indexPath.row]
        
        let crossCells = game1!.findIntersections(at: pressedCell!)
        
        game1?.score += crossCells.count
        
        for cell in crossCells {
            if let crossCell = cell {
                
                game1?.battleField[crossCell.y][crossCell.x]?.value = ""

                var collectionCell = collectionView.cellForItem(at: IndexPath(row: crossCell.x, section: crossCell.y)) as! CollectionCell
                
                collectionCell.backgroundColor = UIColor(named: K.Colors.crossCellColor)

                starIsFalling(
                    starImage: collectionCell.image.image!,
                    fromPosition: collectionCell.layer.frame,
                    color: UIColor(named: crossCell.value!)!)
                
                collectionView.reloadItems(at: [IndexPath(row: crossCell.x, section: crossCell.y)])
            }
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func restartGame(_ sender: Any) {
        startNewGame()
    }
    
    func starIsFalling( starImage: UIImage, fromPosition frame: CGRect, color: UIColor){
        let imageView = UIImageView(image: starImage)
        imageView.tintColor = color
        
        imageView.frame = frame

        print("origin frame - \(frame)")
    
        collectionView.addSubview(imageView)

        UIView.animate(withDuration: 1) {
            imageView.layer.frame.origin.y += (self.collectionView.frame.height - imageView.frame.origin.y )
        }
        
        
    }
}

