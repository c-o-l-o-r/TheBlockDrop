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
        let defaults = UserDefaults()
        let soundDisabled = defaults.bool(forKey: "soundDisabled")
        let adsDisabled = defaults.bool(forKey: "adsDisabled")
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Determine which node (aka button) was touched
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        // Switch on the button's name and depress the button
        if let name = touchedNode.name
        {
            if name == "PLAY"
            {
                playButton.run(SKAction.scale(to: 0.9, duration: 0.2))
            } else if name == "SCORES" {
                scoresButton.run(SKAction.scale(to: 0.9, duration: 0.2))
            } else if name == "SOUND" {
                soundButton.run(SKAction.scale(to: 0.95, duration: 0.2))
            } else if name == "RATE" {
                rateButton.run(SKAction.scale(to: 0.95, duration: 0.2))
            } else if name == "ADS" {
                adsButton.run(SKAction.scale(to: 0.95, duration: 0.2))
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Determine which node (aka button) was touched
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        // If the touch moved off the button, return the button to its default state
        if let name = touchedNode.name
        {
            if name == "BG"
            {
                playButton.run(SKAction.scale(to: 1.0, duration: 0.15))
                scoresButton.run(SKAction.scale(to: 1.0, duration: 0.15))
                soundButton.run(SKAction.scale(to: 1.0, duration: 0.15))
                rateButton.run(SKAction.scale(to: 1.0, duration: 0.15))
                adsButton.run(SKAction.scale(to: 1.0, duration: 0.15))
                
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Determine which node (aka button) was touched
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        // Switch on the buttons name and change scenes based on where the touch was lifted up
        if let name = touchedNode.name
        {
            if name == "PLAY"
            {
                playButton.run(SKAction.scale(to: 1.0, duration: 0.2))
                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.3)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            } else if name == "SCORES" {
                scoresButton.run(SKAction.scale(to: 1.0, duration: 0.2))
                NotificationCenter.default.post(name: Notification.Name(rawValue: "showLeaderboard"), object: nil)
                
            } else if name == "SOUND" {
                let defaults = UserDefaults()
                let soundDisabled = defaults.bool(forKey: "soundDisabled")
                
                if soundDisabled {
                    soundButton.texture = SKTexture(imageNamed: "sound-on.png")
                    defaults.set(false, forKey: "soundDisabled")
                    defaults.synchronize()
                } else {
                    soundButton.texture = SKTexture(imageNamed: "sound-off.png")
                    defaults.set(true, forKey: "soundDisabled")
                    defaults.synchronize()
                }
                soundButton.run(SKAction.scale(to: 1.0, duration: 0.2))
                
                
            } else if name == "ADS" {
                adsButton.run(SKAction.scale(to: 1.0, duration: 0.2))
                //let product = SKProductsRequest(productIdentifiers: "")
                //let payment = SKMutablePayment(product: product)
                
                
            }
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
