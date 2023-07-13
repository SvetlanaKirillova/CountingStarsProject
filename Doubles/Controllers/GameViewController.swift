//
//  ViewController.swift
//  Doubles
//
//  Created by Svetlana Kirillova on 02.06.2023.
//

import UIKit

class GameViewController: UIViewController {

    
    let defaults = UserDefaults.standard

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var levelMenu: UIButton!
    
    let height = 16
    let width = 12
    var cellEdge = 0.0

    var game: GameBrain?
    
    let reuseIdentifier = "cell"
    
    let qtyOfCellsForLevel = [1:4, 2:10, 3: 14, 4:18, 5:22]
    var maxUnlockedLevel = 1
    var currentLevel = 1 {
        didSet {
            setupLevelsMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.navigationController!.navigationBar.barStyle = .black
         
        maxUnlockedLevel = defaults.integer(forKey: K.levelDefaultsKey) != 0 ? defaults.integer(forKey: K.levelDefaultsKey): 1
        currentLevel = maxUnlockedLevel
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupLevelsMenu()
        startNewGame(atLevel: currentLevel)
    }

    
    func startNewGame(atLevel level: Int){

        print("Level = \(level)")
        print("Count of a color for this level = \(qtyOfCellsForLevel[level]! )")

        game = GameBrain(fieldHeight: height, fieldWidth: width, colorQnt: qtyOfCellsForLevel[level]!)

        collectionView.reloadData()
        reloadViews()
    }
    
    
    func reloadViews(){
        if let theGame = game {
            self.scoreLabel.text = "SCORE: \(theGame.score)"
        }
        
    }
    
    
    func setupLevelsMenu(){
        
        var  menuElements = [UIAction]()
        
        for levelNumber in qtyOfCellsForLevel.keys.sorted() {
            
            menuElements.append(UIAction(
                title: "Level \(levelNumber)",
                attributes: levelNumber > maxUnlockedLevel ? .disabled : UIMenuElement.Attributes() ,
                state: levelNumber == currentLevel ? .on : .off,
                handler: { action in
                    
                    if levelNumber != self.currentLevel {
                        self.currentLevel = levelNumber
                        self.startNewGame(atLevel: levelNumber)
                    }
                    
            }))
            
            
        }
        
        levelMenu.menu = UIMenu(title: "", children: menuElements)

        
    }
   
    
    @IBAction func restartGame(_ sender: Any) {
        startNewGame(atLevel: currentLevel)
    }
    
    
    func starsAreFalling( starImage: UIImage, fromPosition frame: CGRect, color: UIColor, finished: (() -> Void )?){
        
        let imageView = UIImageView(image: starImage)
        imageView.tintColor = color
        
        imageView.frame = frame
    
        collectionView.addSubview(imageView)
        
        UIView.animate(withDuration: 0.8) {
            
            imageView.layer.frame.origin.y += (self.collectionView.layer.frame.height - imageView.layer.frame.origin.y )
            
        } completion: { done in
            finished?()
        }

        self.scoreLabel.text = "SCORE: \(self.game!.score)"
        
    }
    
    
    func checkLevel(){
        
        if game?.score == qtyOfCellsForLevel[currentLevel]! * 7 { //todo: multyply on number of avaiable colors
            
            if currentLevel == 5 {
                scoreLabel.text = "GAME OVER!"
                print("Game over!")
                return
            }
            
            
            if currentLevel == maxUnlockedLevel {
                maxUnlockedLevel += 1
                saveMaxUnlockedLevelOnDevice()
                
                print("Max unlocked level is changed to \(maxUnlockedLevel)")
            }
            
            currentLevel += 1
            print("Current level is changed to \(currentLevel)")
            
            self.startNewGame(atLevel: currentLevel)
  
            
        }
    }
    
    // MARK: - Saving Defaults Methods
    
    func saveMaxUnlockedLevelOnDevice(){
        defaults.set(maxUnlockedLevel, forKey: K.levelDefaultsKey)
    }
}


// MARK: - CollectionView Data Source Methods

extension GameViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return height
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return width
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let y = indexPath.section
        let x = indexPath.row


        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionCell

        cell.layer.borderWidth = 0.2
        cell.layer.borderColor = UIColor(named: K.Colors.selectedCellColor)?.cgColor
        if let cellValue = game?.battleField[y][x]?.value {
            if cellValue != "" {
                cell.image.tintColor = UIColor(named: cellValue)
            } else {
                cell.image.isHidden = true
            }
        }
    
        return cell
    }

}


// MARK: - CollectionView Delegate Methods

extension GameViewController: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if game?.battleField[indexPath.section][indexPath.row]?.value != "" {

            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let pressedCell = game?.battleField[indexPath.section][indexPath.row]
        
        let crossCells = game!.findIntersections(at: pressedCell!)
        
        game?.score += crossCells.count
        
        
        for cell in crossCells {
            if let crossCell = cell {
                
                game?.battleField[crossCell.y][crossCell.x]?.value = ""

                var collectionCell = collectionView.cellForItem(at: IndexPath(row: crossCell.x, section: crossCell.y)) as! CollectionCell
                
                collectionCell.backgroundColor = UIColor(named: K.Colors.crossCellColor)

                starsAreFalling(starImage: collectionCell.image.image!,
                              fromPosition: collectionCell.layer.frame,
                              color: UIColor(named: crossCell.value!)!) {
                
                    self.checkLevel()
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                }
                
                collectionView.reloadItems(at: [IndexPath(row: crossCell.x, section: crossCell.y)])
                
            }
        }

        
        self.collectionView.deselectItem(at: indexPath, animated: true)
           

        
    }
    

}
 


// MARK: - CollectionView Delegate Flow Layout Methods

extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        cellEdge = view.frame.width/Double(width)
        return CGSize(width: cellEdge-0.2, height: cellEdge-0.2)
    }
}
