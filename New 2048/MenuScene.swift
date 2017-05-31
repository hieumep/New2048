//
//  MenuScene.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/17/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import SpriteKit
import FacebookShare

class MenuScene : SKScene {
    var continueButton : SKSpriteNode?
    var gameVsAIButton : SKSpriteNode?
    var newButton : SKSpriteNode!
    var rateButton : SKSpriteNode!
    var soundButton : SKSpriteNode!
    var paddingY : CGFloat = 150
    var facebookButton : SKSpriteNode!
    var flagSound = true
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupNewButton()
        setupContinueButton()
        setupGameVsAIButton()
        setupRateButton()
        setupSoundButton()
        //setupFacebookButton()
    }
    
    //setup sound Button
    func setupSoundButton() {
        let soundTexture = SKTexture(image: #imageLiteral(resourceName: "SoundButton"))
        soundButton = SKSpriteNode(texture: soundTexture)
        soundOnOff()
        soundButton.zPosition = 1
        soundButton.position = CGPoint(x: 150 , y: paddingY + newButton.size.height + soundButton.size.height / 2)
        addChild(soundButton)
    }
    
    //setup newButton 
    func setupNewButton() {
        newButton = SKSpriteNode(imageNamed: "NewGameButton")
        newButton.zPosition = 1
        newButton.position = CGPoint(x: 0 , y: paddingY / 3 + newButton.size.height / 2)
        addChild(newButton)
    }
    
    //setup continueButton
    func setupContinueButton() {
        if let _ = UserDefaults.standard.object(forKey: "bestScore") as? Int{
            continueButton = SKSpriteNode(imageNamed: "ContinueButton")
            continueButton?.zPosition = 1
            continueButton?.position = CGPoint(x: 0, y: paddingY + (continueButton?.size.height)! / 2)
            addChild(continueButton!)
        }
        
    }
    
    func setupGameVsAIButton(){
        gameVsAIButton = SKSpriteNode(imageNamed: "GameVsAIButton")
        gameVsAIButton?.zPosition = 1
        gameVsAIButton?.position = CGPoint(x: 0, y: -paddingY / 3 + gameVsAIButton!.size.height / 2 )
        addChild(gameVsAIButton!)
    }
    
    //setup rate button
    func setupRateButton(){
        rateButton = SKSpriteNode(imageNamed: "RateButton")
        rateButton.zPosition = 1
        rateButton.position = CGPoint(x: 0, y: -(paddingY + rateButton.size.height / 2))
        addChild(rateButton)
    }
    
    //setup facebook button
    func setupFacebookButton(){
        facebookButton = SKSpriteNode(imageNamed: "logoFB")
        facebookButton.zPosition = 1
        facebookButton.position = CGPoint(x : -62.5 , y : rateButton.position.y - paddingY / 3 - facebookButton.size.height / 2)
        addChild(facebookButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
        if newButton.contains(touchLocation!){
            let gameScene = GameScene(size: self.size, newGame: true)
            view?.presentScene(gameScene, transition: reveal)
            
        }
        
        if let continueButton = continueButton {
            if continueButton.contains(touchLocation!){
                if let funAI = UserDefaults.standard.object(forKey: "funAI") as? Bool{
                   let gameAIScene = GameVsAiScene(size: size, newGame: false, funAI: funAI)
                    view?.presentScene(gameAIScene, transition: reveal)
                }else {
                    let gameScene = GameScene(size: self.size, newGame: false)
                    view?.presentScene(gameScene, transition: reveal)
                }
            }
        }
        
        if let gameVsAIButton = gameVsAIButton {
            if gameVsAIButton.contains(touchLocation!) {
                let revealAI = SKTransition.doorsCloseVertical(withDuration: 0.5)
                let menuAIScene = MenuAIScene(size: size)
                view?.presentScene(menuAIScene, transition: revealAI)
            }
        }
        
        if rateButton.contains(touchLocation!){
            rateAndReview()
        }
        
        if soundButton.contains(touchLocation!){
            flagSound = !flagSound
            UserDefaults.standard.set(flagSound, forKey: "sound")
            soundOnOff()
        }
    }
    
    func soundOnOff(){
        let soundTexture : SKTexture!
        if let sound = UserDefaults.standard.object(forKey: "sound") as? Bool {
            flagSound = sound
        }
        if flagSound {
            soundTexture = SKTexture(image: #imageLiteral(resourceName: "SoundButton"))
        }else {
            soundTexture = SKTexture(image: #imageLiteral(resourceName: "MuteSoundButton"))
        }
        soundButton.texture = soundTexture
        
    }
    
    func rateAndReview(){
        let url = URL(string : "itms-apps://itunes.apple.com/gb/app/id1242708820?action=write-review&mt=8")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
        print("da an vao")
    }
    
//    func facebookShare(){
//        let myContent = LinkShareContent(url: NSURL(string: "https://developers.facebook.com")! as URL)
//        let shareDialog = ShareDialog(content: myContent)
//        shareDialog.mode = .native
//        shareDialog.failsOnInvalidData = true
//        shareDialog.completion = { result in
//            // Handle share results
//            print("facebook share")
//        }
//        
//        do {
//            try shareDialog.show()
//        }catch {
//        
//        }
//    }
}
