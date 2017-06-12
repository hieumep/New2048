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
    var striclyAIButton : SKSpriteNode?
    var funAIButton : SKSpriteNode!
    var menuButton : SKSpriteNode!
    var paddingY : CGFloat = 150
    var flagFunAI = true // if false = locked
    var flagStrictlyAI = false
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupFunAIButton()
        setupStriclyAIButton()
        setupMenuButton()
    }
    
    //setup FunAIButton
    func setupFunAIButton() {
        let texture : SKTexture
        if let flag = UserDefaults.standard.object(forKey: Constants.funAIMode) as? Bool {
            flagFunAI = flag
        }
        if flagFunAI {
            texture = SKTexture(image: #imageLiteral(resourceName: "FunAIButton"))
        }else {
            texture = SKTexture(image: #imageLiteral(resourceName: "FunAILocked"))
        }
        funAIButton = SKSpriteNode(texture: texture)
        funAIButton.zPosition = 1
        funAIButton.position = CGPoint(x: 0 , y: paddingY / 3 + funAIButton.size.height / 2)
        addChild(funAIButton)
    }
    
    
    // setup striclyAIButton
    func setupStriclyAIButton(){
        let texture : SKTexture
        if let flag = UserDefaults.standard.object(forKey: Constants.strictlyAIMode) as? Bool {
            flagStrictlyAI = flag
        }
        if flagStrictlyAI {
            texture = SKTexture(image: #imageLiteral(resourceName: "StriclyAIButton"))
        } else {
            texture = SKTexture(image: #imageLiteral(resourceName: "StrictlyAILocked"))
        }
        striclyAIButton = SKSpriteNode(texture: texture)
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
            if flagFunAI {
                let gameVsAiScene = GameVsAiScene(size: self.size, newGame: true, funAI : true)
                view?.presentScene(gameVsAiScene, transition: reveal)
            } else {
                alert(funAI: true)
            }
        }
        
        if let striclyAIButton = striclyAIButton {
            if striclyAIButton.contains(touchLocation!) {
                if flagStrictlyAI {
                    let gameVsAiScene = GameVsAiScene(size: self.size, newGame: true, funAI : false)
                    view?.presentScene(gameVsAiScene, transition: reveal)
                } else {
                    alert(funAI: false)
                }
            }
        }
        
        if menuButton.contains(touchLocation!) {
            let revealClose = SKTransition.doorsCloseVertical(withDuration: 0.5)
            let menuScene = MenuScene(size: size)
            view?.presentScene(menuScene, transition: revealClose)
        }
    }
    
    func alert(funAI : Bool){
        var text = ""
        if funAI{
            text = "If you get 2048 tile , you can unlock this mode"
        }else {
            text = "If you get 4096 tile , you can unlock this mode"
        }
        let alert = UIAlertController(title: "Unlock", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
