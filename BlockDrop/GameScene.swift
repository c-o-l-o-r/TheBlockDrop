//
//  GameScene.swift
//  BlockDrop
//
//  Created by Matt Garnett on 7/26/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import SpriteKit
import AudioToolbox
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Player declaration
    var player : SKSpriteNode!
    var instructions : SKSpriteNode!
    var scoreBoard : SKLabelNode!
    
    // Array of obstacle nodes
    var levels : [MGLevel] = []
    
    // Helper variables
    var playerIsDead = false
    var numLevels = 0
    var score = 0
    
    // Initialize game
    override func didMove(to _: SKView) {
        backgroundColor = SKColor.white
        self.physicsWorld.gravity = kGRAVITY
        self.physicsWorld.contactDelegate = self
        
        instructions = SKSpriteNode(imageNamed: "instructions.png")
        instructions.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 60)
        addChild(instructions)
        
        scoreBoard = SKLabelNode(fontNamed: "comic andy")
        scoreBoard.text = "0"
        scoreBoard.fontColor = .black
        scoreBoard.fontSize = 48
        scoreBoard.position = CGPoint(x: self.frame.width - 10, y: 13)
        scoreBoard.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        addChild(scoreBoard)
        
        addBoundries()
        addPlayer()
        addLevel(self.frame.height / 4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            if playerIsDead { return }
            
            // Determine location of touch
            if touch.location(in: self).x < self.frame.width / 2 {
                // Touch is on left half of screen
                player.physicsBody?.velocity = CGVector(dx: 0, dy:0)
                player.physicsBody?.applyImpulse(kLEFT_IMPULSE)
            } else {
                // Touch is on right half of screen
                player.physicsBody?.velocity = CGVector(dx: 0, dy:0)
                player.physicsBody?.applyImpulse(kRIGHT_IMPULSE)
            }
            
            // Turn on gravity for the player if this is the first touch
            if(!(player.physicsBody?.affectedByGravity)!) {
                player.physicsBody?.affectedByGravity = true
                
                // Remove instructions graphic
                let a = SKAction.fadeOut(withDuration: 0.15)
                instructions.run(a, completion: ( {
                    self.instructions.removeFromParent()
                } ))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if(player.physicsBody?.affectedByGravity == true && player.position.y < self.frame.height / 2 + player.size.width + 5) {
           
            for level in levels {
                level.moveUpBy(kGAME_SPEED + CGFloat(score / 10))
                
                if !level.hasLevelBeenCompleted() && level.getCurrentHeight() > player.position.y {
                    score += 1
                    print("\(score)")
                    scoreBoard.text = "\(score)"
                    level.completeLevel()
                }
            }
        }
        
        if levels.last?.getCurrentHeight() > self.frame.height / 2 {
            addLevel(-25)
        }
        
        if levels.first?.getCurrentHeight() > self.frame.height + self.frame.height / 2 {
            levels.first?.removeNodesFromParent()
            levels.remove(at: 0)        }
    }
    
    func changeScenes() {
        
        if #available(iOS 9.0, *) {
            let action = SKAction.applyForce(CGVector(dx: 0, dy: 0), duration: 1)
            player.run(action, completion: {
                let transition = SKTransition.fade(with: .white, duration: 0.5)
                let gameOverScene = GameOverScene(size: self.size, score: self.score)
                self.view?.presentScene(gameOverScene, transition: transition)
            })
        } else {
            let transition = SKTransition.fade(with: .white, duration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, score: self.score)
            self.view?.presentScene(gameOverScene, transition: transition)
        }

    }
    
    func loadRevMob() {
        
        let fs = RevMobAds.session().fullscreen()
        let completionBlock: (RevMobFullscreen?) -> Void = {fullscreen in
            fullscreen?.showAd()
                    }
        let failureBlock: (RevMobFullscreen?,Error?) -> Void = { fullscreen,error in
            NSLog("[RevMob Sample App] Fullscreen failed to load with error: \(error?.localizedDescription)")
            self.changeScenes()
        }
        let onClickHandler: () -> Void = { fullscreen in
            let gameOverScene = GameOverScene(size: self.size, score: self.score)
            self.view?.presentScene(gameOverScene)

        }
        let onCloseHandler: () -> Void = {
            let gameOverScene = GameOverScene(size: self.size, score: self.score)
            self.view?.presentScene(gameOverScene)
        }
        fs?.load(successHandler: completionBlock, andLoadFailHandler: failureBlock, onClickHandler: onClickHandler, onCloseHandler: onCloseHandler)
    }

    
    // Determine if the player came into contact w/ an obstacle, and end the game if necessary
    func didBegin(_ contact: SKPhysicsContact) {
        if(contact.bodyA.node?.name != "MOVER" && contact.bodyB.node?.name != "MOVER" && contact.bodyA.node?.name != "BOUNDARY" && contact.bodyB.node?.name != "BOUNDARY" && !playerIsDead) {
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            playCount = playCount + 1
            playerIsDead = true
            player.physicsBody?.allowsRotation = true;
            player.physicsBody?.applyImpulse(CGVector(dx: CGFloat(arc4random_uniform(10)), dy: CGFloat(10 + arc4random_uniform(25))))
            
            if(playCount % 5 == 0 && canShowAds) {
                loadRevMob()
            } else {
                changeScenes()
            }
        }
    }
}
