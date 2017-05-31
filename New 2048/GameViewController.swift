//
//  GameViewController.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/8/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    let boardGame = BoardGame()
    //var scene : MenuScene!
    var radioWidth : CGFloat! = 1
    var radioHeight : CGFloat! = 1
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-5300329803332227/4886181799"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID]
        bannerView.load(request)
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        let size = CGSize(width: 414, height: 736)
       
        let scene = MenuScene(size: size)
        //let scene = EndGameScene(size: size, isWin: true, highestNodeNumber : 4096)
        //let scene = EndGameAIScene(size: size, playerScore: 2, AIScore: 4)
        //let scene = GameVsAiScene(size: size, newGame: true)
        let skView = view as! SKView!
        //scene.scaleMode = .aspectFill
        skView?.presentScene(scene)

    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
