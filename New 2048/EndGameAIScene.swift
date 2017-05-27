//
//  EndGameAIScene.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/23/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import SpriteKit

class EndGameAIScene : SKScene {
    
    let winText = "You Win! I'll win next time "
    let loseText =  "You lose!Can you beat me next time?"
    var winLabel = SKLabelNode()
    var loseLabel = SKLabelNode()
    var playerScore : Int
    var AIScore : Int
    var newButton : SKSpriteNode!
    let playerScoreLabel = SKLabelNode(text: "0")
    let AIScoreLabel = SKLabelNode(text: "0")
    let playerNode = SKSpriteNode(imageNamed: "Score_Bg")
    let AINode = SKSpriteNode(imageNamed: "bestScore_Bg")
    
    init(size: CGSize, playerScore : Int, AIScore : Int) {
        self.AIScore = AIScore
        self.playerScore = playerScore
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
        if playerScore > AIScore {
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
        winLabel.position = CGPoint(x: 0, y: 250)
        addChild(winLabel)
        
        let size = playerNode.size
        let bigSize = CGSize(width: size.width * 2, height: size.height * 1.5)
        let move = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 2.0)
        playerNode.run(SKAction.group([move, SKAction.scale(to: bigSize, duration: 2.0)]))
    }
    
    func animateLose(){
        loseLabel.fontName = "Arial" // tim font moi
        loseLabel.fontSize = 25
        loseLabel.position = CGPoint(x: 0, y: 250)
        addChild(loseLabel)
        
        let size = AINode.size
        let bigSize = CGSize(width: size.width * 2, height: size.height * 1.5)
        let move = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 2.0)
        AINode.run(SKAction.group([move, SKAction.scale(to: bigSize, duration: 2.0)]))
    }
    
    func setupNewButton() {
        newButton = SKSpriteNode(imageNamed: "Menu_horz")
        newButton.zPosition = 1
        newButton.position = CGPoint(x: 0 , y: -(150 + newButton.size.height / 2))
        addChild(newButton)
        
        playerNode.position = CGPoint(x: -127.5, y: 180)
        addChild(playerNode)
        
        playerScoreLabel.text = "\(playerScore)"
        playerScoreLabel.horizontalAlignmentMode = .center
        playerScoreLabel.verticalAlignmentMode = .center
        playerScoreLabel.fontName = "Arial"
        playerScoreLabel.fontSize = 25
        playerNode.addChild(playerScoreLabel)
        
        AINode.position = CGPoint(x: 127.5, y: 180)
        addChild(AINode)
        
        AIScoreLabel.text = "\(AIScore)"
        AIScoreLabel.horizontalAlignmentMode = .center
        AIScoreLabel.verticalAlignmentMode = .center
        AIScoreLabel.fontName = "Arial"
        AIScoreLabel.fontSize = 25
        AINode.addChild(AIScoreLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        
        if newButton.contains(touchLocation!){
            let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
            let gameScene = MenuScene(size: size)
            view?.presentScene(gameScene, transition: reveal)
            
        }
    }
    
}
