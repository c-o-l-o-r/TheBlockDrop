//
//  GameViewController.swift
//  BlockDrop
//
//  Created by Matt Garnett on 7/26/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    
    var bannerView: RevMobBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showLeaderboard), name: NSNotification.Name(rawValue: "showLeaderboard"), object: nil)
        
        let scene = MainMenu(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        let completionBlock: () -> Void = {
            //Custom method defined below
            canShowAds = true
            self.showBannerWithCustomFrame(scene)
        }
        
        let failureBlock: (Error?) -> Void = {error in
            NSLog("[RevMob Sample App] Session failed to start with error: \(error!.localizedDescription)")
            canShowAds = false
        }
    
    RevMobAds.startSession(withAppID: "57a2b2e6f1c368630b7984f8",
    withSuccessHandler: completionBlock,
    andFailHandler: failureBlock)
}

func showBannerWithCustomFrame(_ scene: SKScene){
    bannerView = RevMobAds.session().bannerView()
    let completionBlock: (RevMobBannerView?) -> Void = { bannerV in
        let x = CGFloat(0)
        let y = CGFloat(0)
        let width = CGFloat(scene.size.width)
        let height = CGFloat(60)
        self.bannerView!.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
        self.bannerView!.autoresizingMask = [.flexibleTopMargin, .flexibleWidth] //Optional Parameters to handle Rotation Events
        self.view.addSubview(self.bannerView!)
    }
    let failureHandler: (RevMobBannerView?, Error?) -> Void = {bView, error in
        NSLog("[RevMob Sample App] BannerView failed to load with error: \(error!.localizedDescription)")
    }
    let clickHandler: (RevMobBannerView?) -> Void = {bView in
        NSLog("[RevMob Sample App] BannerView Clicked")
    }
    self.bannerView!.load(successHandler: completionBlock, andLoadFailHandler: failureHandler, onClickHandler: clickHandler)
}

    func showLeaderboard() {
        
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.leaderboards
        gcVC.leaderboardIdentifier = "block_drop_highscores"
        self.present(gcVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gcViewController: GKGameCenterViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
