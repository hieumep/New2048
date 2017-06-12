//
//  GameScene.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/8/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let padding : CGFloat = 14.4
    let tileWidth : CGFloat = 72
    
    var continueGameWhen2048 = false
    
    var score = 0 {
        didSet{
            scoreText.text = "\(score)"
        }
    }
    
    var bg : SKSpriteNode!
    var arrayNodes = Array2D<SKSpriteNode>(columns: 4, rows: 4)
    var newGame = true
    var boardGame = BoardGame()
    var swipeAbleFlag = true
    var flagSound = true
    
    var highestNodeNumber = 8 {
        didSet{
            let imageName = "Node_Bg_\(highestNodeNumber)"
            let texture = SKTexture(imageNamed: imageName)
            highestNode.texture = texture
            print(highestNodeNumber)
        }
    }
    
    var bestScore = 0 {
        didSet{
            bestScoreText.text = "\(bestScore)"
            UserDefaults.standard.set(bestScore, forKey: "bestScore")
            UserDefaults.standard.set(nil, forKey : "funAI")
        }
    }
    
    var scoreText : SKLabelNode!
    let bestScoreText = SKLabelNode(text: "0")
    let highestNode = SKSpriteNode(imageNamed: "Node_Bg_8")
    var continueButton : SKSpriteNode?
    var newGameButton : SKSpriteNode?
    var continueSceneNode : SKSpriteNode?
    var menuButton : SKSpriteNode?
    
    
    init(size: CGSize, newGame : Bool) {
        super.init(size: size)
        self.newGame = newGame
        if let sound = UserDefaults.standard.object(forKey: "sound") as? Bool {
            flagSound = sound
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //self.backgroundColor = SKColor.white
        setupBackground()
        setupNumberNodes()
        setupSwipeGesture()
        setupHighestNode()
        setupScoreBoard()
        if let bestScore = UserDefaults.standard.object(forKey: "bestScore") as? Int {
            boardGame.bestScore = bestScore
        }
        bestScore = boardGame.bestScore
        if newGame {
            beginGame()
        }else {
            if let gameState = loadGameState(){
                boardGame.loadGame = true
                boardGame.score = gameState.score
                boardGame.highestNode = gameState.highestNode
                score = gameState.score
                highestNodeNumber = gameState.highestNode
                loadPauseGame(gameState.gameArray)
            }
        }
    }
    
    //check Load Game State
    func loadGameState() -> GameState?{
        if let data = UserDefaults.standard.object(forKey: "gameState") as? Data {
            let gameState = NSKeyedUnarchiver.unarchiveObject(with: data) as? GameState
            return gameState
        }
        return nil
    }
    
    //load pause game
    func loadPauseGame(_ gameArray : Array2D<NumberNode>){
        for column in 0 ..< gameArray.columns {
            for row in 0 ..< gameArray.rows {
                if let node = gameArray[column, row] {
                    if node.number > 0 {
                        boardGame.gameArray[node.column, node.row] = node
                        animateNewNode(node: node)
                    }
                }
            }
        }
        //  boardGame.printArray()
    }
    
    //load begin game with 2 node random
    func beginGame() {
        for _ in 0 ..< 2 {
            if let numNode = boardGame.randomNumberNode() {
                boardGame.gameArray[numNode.column, numNode.row] = numNode
                animateNewNode(node: numNode)
            }
        }
    }
    
    //setup swipe Gesture {
    func setupSwipeGesture(){
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(gesture:)))
        swipeGestureLeft.direction = .left
        view?.addGestureRecognizer(swipeGestureLeft)
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(gesture:)))
        swipeGestureRight.direction = .right
        view?.addGestureRecognizer(swipeGestureRight)
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(gesture:)))
        swipeGestureUp.direction = .up
        view?.addGestureRecognizer(swipeGestureUp)
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(gesture:)))
        swipeGestureDown.direction = .down
        view?.addGestureRecognizer(swipeGestureDown)
    }
    
    // func detect Swipe
    func swipeAction(gesture : UISwipeGestureRecognizer){
        var (array, score) : ([[NumberNode]], Int) = ([[]], 0)
        if swipeAbleFlag {
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.left :
                print("left")
                (array,score) = boardGame.swipeBoard(moveDirection: .left)
            case UISwipeGestureRecognizerDirection.right :
                print("right")
                (array,score) = boardGame.swipeBoard(moveDirection: .right)
            case UISwipeGestureRecognizerDirection.up :
                print("up")
                (array,score) = boardGame.swipeBoard(moveDirection: .up)
            //  animateMoveNode(array: array,score: score)
            case UISwipeGestureRecognizerDirection.down :
                print("down")
                (array,score) = boardGame.swipeBoard(moveDirection: .down)
            default :
                print("default")
            }
            
            animateMoveNode(array: array,score: score) {
                self.swipeAbleFlag = true
                self.removeAllActions()
                if !self.boardGame.isFull() {
                    if self.boardGame.is2048 {
                        if self.continueGameWhen2048 {
                            if !array.isEmpty {
                                if self.boardGame.is4096 && self.boardGame.flagShowUnlock4096{
                                    self.continueScene(unlock: true, number: 4096)
                                    self.boardGame.flagShowUnlock4096 = false
                                }
                                let newNode = self.boardGame.randomNumberNode()
                                self.animateNewNode(node: newNode!)
                            }
                        }else {
                            if self.boardGame.flagShowUnlock2048 {
                                self.continueScene(unlock: true, number: 2048)
                                self.boardGame.flagShowUnlock2048 = false
                            }else {
                                self.continueScene(unlock: false, number: 0)
                            }
                            if !array.isEmpty {
                                let newNode = self.boardGame.randomNumberNode()
                                self.animateNewNode(node: newNode!)
                            }
                        }
                        
                    }else {
                        if !array.isEmpty {
                            let newNode = self.boardGame.randomNumberNode()
                            self.animateNewNode(node: newNode!)
                        }
                    }
                }
                
                self.score += score
            }
        }
    }
    
    
    //setup background
    func setupBackground(){
        let bgTexture = SKTexture(image: #imageLiteral(resourceName: "Background"))
        bg = SKSpriteNode(texture: bgTexture, color: .white, size: bgTexture.size())
        bg.position = CGPoint(x: 0, y: -60)
        bg.zPosition = -2
        addChild(bg)
        
    }
    
    //setup cac node nen
    func setupNumberNodes(){
        let boardNode = boardGame.gameArray
        for column in 0 ..< 4 {
            for row in 0 ..< 4 {
                let numberNode = boardNode[column,row]
                let skNode = SKSpriteNode(texture: numberNode?.texture, size: numberNode!.texture.size())
                skNode.position = pointAt(column: column, row: row)
                skNode.zPosition = -1
                addChild(skNode)
                
            }
        }
    }
    
    //setup highest Node
    func setupHighestNode (){
        highestNode.size = CGSize(width: 108, height: 108)
        highestNode.zPosition = 0
        let width = -bg.size.width / 2 + 54
        highestNode.position = CGPoint(x:width , y: bg.size.height/2 + 60 )
        addChild(highestNode)
        
        menuButton = SKSpriteNode(imageNamed: "MenuButton")
        menuButton?.zPosition = 3
        menuButton?.position = CGPoint(x: -width + 16, y: highestNode.position.y)
        addChild(menuButton!)
    }
    
    //setup scoreBoard
    func setupScoreBoard(){
        let score_bg = SKSpriteNode(imageNamed: "Score_Bg")
        score_bg.position = CGPoint(x: -score_bg.size.width/2 + 30, y: highestNode.position.y + 29)
        addChild(score_bg)
        scoreText = SKLabelNode(text: "\(score)")
        scoreText.zPosition = 3
        scoreText.fontName = "Arial"
        scoreText.fontSize = 25
        scoreText.horizontalAlignmentMode = .center
        scoreText.verticalAlignmentMode = .center
        score_bg.addChild(scoreText)
        
        let bestScore_Bg = SKSpriteNode(imageNamed: "bestScore_Bg")
        bestScore_Bg.position = CGPoint(x: score_bg.position.x, y: score_bg.position.y - bestScore_Bg.size.height - 8)
        addChild(bestScore_Bg)
        bestScoreText.zPosition = 3
        bestScoreText.fontName = "Arial"
        bestScoreText.fontSize = 25
        bestScoreText.verticalAlignmentMode = .center
        bestScoreText.horizontalAlignmentMode = .center
        bestScore_Bg.addChild(bestScoreText)
    }
    
    // Convert Int to CGPoint
    func pointAt(column : Int, row : Int) -> CGPoint{
        let anchorX : CGFloat = -bg.size.width / 2 + tileWidth / 2
        let anchorY : CGFloat = -bg.size.height / 2 - 60 + tileWidth / 2
        let position = CGPoint(x: anchorX + padding + (tileWidth + padding) * CGFloat(row) , y: anchorY + padding + (padding + tileWidth) * CGFloat(column) )
        return position
    }
    
    func animateNewNode(node : NumberNode){
        let position = pointAt(column: node.column, row: node.row)
        let size = node.texture.size()
        let skNode = SKSpriteNode(texture: node.texture, size: node.texture.size())
        skNode.size = CGSize(width: size.width / 4, height: size.height / 4)
        let skAction = SKAction.scale(to: size, duration: 0.25)
        skNode.position = position
        skNode.zPosition = 1
        arrayNodes[node.column,node.row] = skNode
        addChild(skNode)
        skNode.run(skAction){
            self.swipeAbleFlag = true
            // check node moi hien ra va ko move duoc xung quanh, va node day bang thi se het game
            if !self.boardGame.canMove() && self.boardGame.isFull() {
                print("End game")
                let scene = EndGameScene(size: self.size, isWin: self.continueGameWhen2048, highestNodeNumber : self.highestNodeNumber)
                let reveal = SKTransition.doorsCloseVertical(withDuration: 1.0)
                self.view?.presentScene(scene, transition: reveal)
            } else {
                print("Continue game")
                
            }
        }
    }
    
    //animate when we swipe screen
    func animateMoveNode(array : [[NumberNode]],score : Int, completion : @escaping (() -> ())){
        swipeAbleFlag = false
        let delay : CGFloat = 0
        var duration = TimeInterval(0)
        var distance = 0
        for subArray in array {
            for (_, node) in subArray.enumerated() {
                
                let skNode = arrayNodes[node.column, node.row]
                let newPosition = pointAt(column: node.newColumn, row: node.newRow)
                if node.column == node.newColumn {
                    distance = abs(node.newRow - node.row)
                }else {
                    distance = abs(node.newColumn - node.column)
                }
                // print("distance is \(distance)")
                duration = TimeInterval(delay + CGFloat(distance) * 0.15)
                if node.mix {
                    let moveAction = SKAction.move(to: newPosition, duration: duration)
                    moveAction.timingMode = .easeOut
                    let fadeOutAction = SKAction.fadeOut(withDuration: 0.15)
                    fadeOutAction.timingMode = .easeOut
                    
                    skNode?.run(SKAction.sequence([moveAction, fadeOutAction,SKAction.removeFromParent()])){
                        self.boardGame.gameArray[node.column, node.row]?.mix = false
                    }
                    // animate when mix
                    let nextNode = self.arrayNodes[node.newColumn, node.newRow]
                    let newTexture = self.boardGame.gameArray[node.newColumn, node.newRow]?.texture
                    let size = nextNode!.size
                    let animateTexture = SKAction.animate(with: [newTexture!], timePerFrame: 0.1)
                    let ZoomOut = SKAction.scale(to: CGSize(width: size.width * 1.2, height: size.height * 1.2), duration: 0.1)
                    let ZoomIn = SKAction.scale(to: size, duration: 0.1)
                    var skActionSequence = SKAction.sequence([])
                    if flagSound {
                        let sound = SKAction.playSoundFileNamed("Mix.wav", waitForCompletion: false)
                        skActionSequence = SKAction.sequence([SKAction.wait(forDuration: duration), animateTexture, sound, ZoomOut,ZoomIn])
                    }   else {
                        skActionSequence = SKAction.sequence([SKAction.wait(forDuration: duration), animateTexture, ZoomOut,ZoomIn])
                    }
                    nextNode?.run(skActionSequence){
                        if self.boardGame.highestNode > self.highestNodeNumber {
                            //change highest Node Number
                            let imageName = "Node_Bg_\(self.boardGame.highestNode)"
                            let texture = SKTexture(imageNamed: imageName)
                            self.highestNode.run(SKAction.animate(with: [texture], timePerFrame: 0.3, resize: false, restore: false)){
                                self.highestNodeNumber = self.boardGame.highestNode
                            }
                        }
                        if self.boardGame.bestScore > self.bestScore {
                            self.bestScore = self.boardGame.bestScore
                        }
                    }
                }else {
                    skNode!.run(SKAction.move(to: newPosition, duration: duration ))
                    self.arrayNodes[node.newColumn,node.newRow] = skNode
                    self.arrayNodes[node.column, node.row] = nil
                }
            }
        }
        run(SKAction.wait(forDuration: duration), completion : completion)
    }
    
    // setup continue sceen when player get 2048
    func continueScene(unlock : Bool, number : Int){
        var node2048Texure = SKTexture(image: #imageLiteral(resourceName: "Node_Bg_2048"))
        if unlock {
            if number == 2048 {
                node2048Texure = SKTexture(image: #imageLiteral(resourceName: "FunAIButton"))
            } else if number == 4096 {
                node2048Texure = SKTexture(image: #imageLiteral(resourceName: "StriclyAIButton"))
            }
        }
        var bgTexture = SKTexture(image: #imageLiteral(resourceName: "Continue_Bg"))
        if unlock {
            bgTexture = SKTexture(image: #imageLiteral(resourceName: "unlockModeBg"))
        }
        
        continueSceneNode = SKSpriteNode(texture: bgTexture)
        continueSceneNode?.zPosition = 5
        continueSceneNode?.position = CGPoint(x: 0, y: 0)
        addChild(continueSceneNode!)
        
        //setup Continue game
        continueButton = SKSpriteNode(imageNamed: "ContinueButton")
        continueButton?.zPosition = 1
        continueButton?.position = CGPoint(x: 0, y: -((continueSceneNode?.size.height)! / 6))
        continueSceneNode?.addChild(continueButton!)
        
        //setup New game
        newGameButton = SKSpriteNode(imageNamed: "NewGameButton")
        newGameButton?.zPosition = 1
        newGameButton?.position = CGPoint(x: 0 , y: -(continueButton!.size.height * 2 + 20))
        continueSceneNode?.addChild(newGameButton!)
        
        //setup 2048 node
        let node2048 = SKSpriteNode(texture: node2048Texure)
        node2048.zPosition = 1
        node2048.position = CGPoint(x: 0, y: node2048.size.height)
        continueSceneNode?.addChild(node2048)
        
        let size2048 = node2048.size
        let scaleBigger = SKAction.scale(to: CGSize(width : size2048.width * 2, height : size2048.height * 2), duration: 1)
        let scaleSmaller = SKAction.scale(to: CGSize(width: size2048.width / 2, height: size2048.height / 2), duration: 1)
        node2048.run(SKAction.repeatForever(SKAction.sequence([scaleBigger,scaleSmaller])))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        
        if let continueButton = continueButton {
            if continueButton.contains(touchLocation!) {
                continueSceneNode?.removeFromParent()
                self.continueGameWhen2048 = true
            }
        }
        
        if let newGameButton = newGameButton{
            if newGameButton.contains(touchLocation!) {
                let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size, newGame: true)
                view?.presentScene(gameScene, transition: reveal)
            }
        }
        
        if let menuButton = menuButton {
            if menuButton.contains(touchLocation!){
                let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                let menuScene = MenuScene(size: self.size)
                view?.presentScene(menuScene, transition: reveal)
            }
        }
    }
}
