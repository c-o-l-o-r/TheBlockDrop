//
//  MainMenu.swift
//  BlockDrop
//
//  Created by Matt Garnett on 8/3/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit
import StoreKit

class MainMenu: SKScene {
    
    var bgImage : SKSpriteNode!
    var playButton : SKSpriteNode!
    var scoresButton : SKSpriteNode!
    var soundButton : SKSpriteNode!
    var rateButton : SKSpriteNode!
    var adsButton : SKSpriteNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Set up scene
        bgImage = SKSpriteNode(imageNamed: "background.png")
        bgImage.name = "BG"
        bgImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bgImage.zPosition = -1
        
        let appName = SKSpriteNode(imageNamed: "BlockDrop.png")
        appName.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.7)
        
        playButton = SKSpriteNode(imageNamed: "playButton.png")
        playButton.name = "PLAY"
        playButton.position = CGPoint(x: self.size.width / 4, y: self.size.height * 0.19)
        
        scoresButton = SKSpriteNode(imageNamed: "scoresButton.png")
        scoresButton.name = "SCORES"
        scoresButton.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.19)

        // Get preferences from user defaults
        let defaults = NSUserDefaults()
        let soundDisabled = defaults.boolForKey("soundDisabled")
        let adsDisabled = defaults.boolForKey("adsDisabled")
        
        soundButton = soundDisabled ? SKSpriteNode(imageNamed: "sound-off.png") : SKSpriteNode(imageNamed: "sound-on.png")
        soundButton.name = "SOUND"
        soundButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.06)
        
        rateButton = SKSpriteNode(imageNamed: "rate.png")
        rateButton.name = "RATE"
        rateButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.06)
        
        adsButton = adsDisabled ? SKSpriteNode(imageNamed: "ads-off.png") : SKSpriteNode(imageNamed: "ads-on.png")
        adsButton.name = "ADS"
        adsButton.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.06)
        
        let mainArt = SKSpriteNode(imageNamed: "block.png")
        mainArt.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.42)
        
        // Add Children
        addChild(bgImage)
        addChild(playButton)
        addChild(scoresButton)
        addChild(soundButton)
        addChild(rateButton)
        addChild(adsButton)
        addChild(mainArt)
        addChild(appName)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Determine which node (aka button) was touched
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        // Switch on the button's name and depress the button
        if let name = touchedNode.name
        {
            if name == "PLAY"
            {
                playButton.runAction(SKAction.scaleTo(0.9, duration: 0.2))
            } else if name == "SCORES" {
                scoresButton.runAction(SKAction.scaleTo(0.9, duration: 0.2))
            } else if name == "SOUND" {
                soundButton.runAction(SKAction.scaleTo(0.95, duration: 0.2))
            } else if name == "RATE" {
                rateButton.runAction(SKAction.scaleTo(0.95, duration: 0.2))
            } else if name == "ADS" {
                adsButton.runAction(SKAction.scaleTo(0.95, duration: 0.2))
            }
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Determine which node (aka button) was touched
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        // If the touch moved off the button, return the button to its default state
        if let name = touchedNode.name
        {
            if name == "BG"
            {
                playButton.runAction(SKAction.scaleTo(1.0, duration: 0.15))
                scoresButton.runAction(SKAction.scaleTo(1.0, duration: 0.15))
                soundButton.runAction(SKAction.scaleTo(1.0, duration: 0.15))
                rateButton.runAction(SKAction.scaleTo(1.0, duration: 0.15))
                adsButton.runAction(SKAction.scaleTo(1.0, duration: 0.15))
                
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Determine which node (aka button) was touched
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        // Switch on the buttons name and change scenes based on where the touch was lifted up
        if let name = touchedNode.name
        {
            if name == "PLAY"
            {
                playButton.runAction(SKAction.scaleTo(1.0, duration: 0.2))
                let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.3)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            } else if name == "SCORES" {
                scoresButton.runAction(SKAction.scaleTo(1.0, duration: 0.2))
                NSNotificationCenter.defaultCenter().postNotificationName("showLeaderboard", object: nil)
                
            } else if name == "SOUND" {
                let defaults = NSUserDefaults()
                let soundDisabled = defaults.boolForKey("soundDisabled")
                
                if soundDisabled {
                    soundButton.texture = SKTexture(imageNamed: "sound-on.png")
                    defaults.setBool(false, forKey: "soundDisabled")
                    defaults.synchronize()
                } else {
                    soundButton.texture = SKTexture(imageNamed: "sound-off.png")
                    defaults.setBool(true, forKey: "soundDisabled")
                    defaults.synchronize()
                }
                soundButton.runAction(SKAction.scaleTo(1.0, duration: 0.2))
                
                
            } else if name == "ADS" {
                adsButton.runAction(SKAction.scaleTo(1.0, duration: 0.2))
                let product = SKProductsRequest(productIdentifiers: "")
                
                let payment = SKMutablePayment(product: product)
                
                
            }
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
