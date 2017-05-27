//
//  MenuAIScene.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/25/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import SpriteKit

class MenuAIScene : SKScene {
    var continueButton : SKSpriteNode?
    var striclyAIButton : SKSpriteNode?
    var funAIButton : SKSpriteNode!
    var menuButton : SKSpriteNode!
    var paddingY : CGFloat = 150
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupFunAIButton()
       // setupContinueButton()
        setupStriclyAIButton()
        setupMenuButton()
    }
    
    //setup FunAIButton
    func setupFunAIButton() {
        funAIButton = SKSpriteNode(imageNamed: "FunAIButton")
        funAIButton.zPosition = 1
        funAIButton.position = CGPoint(x: 0 , y: paddingY / 3 + funAIButton.size.height / 2)
        addChild(funAIButton)
    }
    
    //setup continueButton
    func setupContinueButton() {
        if let _ = UserDefaults.standard.object(forKey: "bestScore") as? Int {
            continueButton = SKSpriteNode(imageNamed: "ContinueButton")
            continueButton?.zPosition = 1
            continueButton?.position = CGPoint(x: 0, y: paddingY + (continueButton?.size.height)! / 2)
            addChild(continueButton!)
        }
        
    }
    
    // setup striclyAIButton
    func setupStriclyAIButton(){
        striclyAIButton = SKSpriteNode(imageNamed: "StriclyAIButton")
        striclyAIButton?.zPosition = 1
        striclyAIButton?.position = CGPoint(x: 0, y: -paddingY / 3 + striclyAIButton!.size.height / 2 )
        addChild(striclyAIButton!)
    }
    
    // setup main menu
    func setupMenuButton(){
        menuButton = SKSpriteNode(imageNamed: "Menu_horz")
        menuButton.zPosition = 1
        menuButton.position = CGPoint(x: 0, y: -(paddingY + menuButton.size.height / 2))
        addChild(menuButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
        if funAIButton.contains(touchLocation!){
            let gameVsAiScene = GameVsAiScene(size: self.size, newGame: true, funAI : true)
            view?.presentScene(gameVsAiScene, transition: reveal)
        }
        
        if let continueButton = continueButton {
            if continueButton.contains(touchLocation!){
                let gameScene = GameScene(size: self.size, newGame: false)
                view?.presentScene(gameScene, transition: reveal)
            }
        }
        
        if let striclyAIButton = striclyAIButton {
            if striclyAIButton.contains(touchLocation!) {
                let gameVsAiScene = GameVsAiScene(size: self.size, newGame: true, funAI : false)
                view?.presentScene(gameVsAiScene, transition: reveal)
            }
        }
        
        if menuButton.contains(touchLocation!) {
            let revealClose = SKTransition.doorsCloseVertical(withDuration: 0.5)
            let menuScene = MenuScene(size: size)
            view?.presentScene(menuScene, transition: revealClose)
        }
    }
}
