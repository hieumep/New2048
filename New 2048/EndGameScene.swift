//
//  EndGameScene.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/19/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import SpriteKit

class EndGameScene : SKScene {
    
    let winText = "You Win!!!The highest node is : "
    let loseText =  "You lose but never give up!!!"
    var winLabel = SKLabelNode()
    var loseLabel = SKLabelNode()
    var isWin : Bool
    var newButton : SKSpriteNode!
    var highestNodeNumber : Int
    
    init(size: CGSize, isWin : Bool, highestNodeNumber : Int) {
        self.isWin = isWin
        self.highestNodeNumber = highestNodeNumber
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        winLabel.text = winText
        loseLabel.text = loseText
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
       // winLabel.physicsBody = SKPhysicsBody(rectangleOf: winLabel.frame.size)
       // winLabel.physicsBody?.isDynamic = false
       // winLabel.
        if isWin {
            animateWin()
        } else {
            animateLose()
        }
        setupNewButton()
    }
    
    //func animate win Label
    func animateWin(){
        winLabel.fontName = "Arial" // tim font moi
        winLabel.fontSize = 25
        winLabel.position = CGPoint(x: 0, y: 150)
        addChild(winLabel)
        
        let numberNode = SKSpriteNode(imageNamed: "Node_Bg_\(self.highestNodeNumber)")
        numberNode.position = CGPoint(x: 0, y: 0)
        let size = numberNode.size
        numberNode.size = CGSize(width: size.width * 0.2, height: size.height * 0.2)
        let bigSize = CGSize(width: size.width * 1.5, height: size.height * 1.5)
        numberNode.run(SKAction.scale(to: bigSize, duration: 2.0))
        addChild(numberNode)
    }
    
    func animateLose(){
        loseLabel.fontName = "Arial" // tim font moi
        loseLabel.fontSize = 25
        loseLabel.position = CGPoint(x: 0, y: 150)
        addChild(loseLabel)
    }
    
    func setupNewButton() {
        newButton = SKSpriteNode(imageNamed: "NewGameButton")
        newButton.zPosition = 1
        newButton.position = CGPoint(x: 0 , y: -(150 + newButton.size.height / 2))
        addChild(newButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        
        if newButton.contains(touchLocation!){
            let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
            let gameScene = GameScene(size: self.size, newGame: true)
            view?.presentScene(gameScene, transition: reveal)
            
        }
    }
    
}
