//
//  GameElements.swift
//  BlockDrop
//
//  Created by Matt Garnett on 8/2/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    // Add the player to the scene
    func addPlayer() {
        player = SKSpriteNode(color: UIColor.blackColor(), size: kPLAYER_SIZE)
        player.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
        player.zRotation = CGFloat(M_PI_4)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = CollisionMask.Player
        player.physicsBody?.contactTestBitMask = CollisionMask.Obstacle
        player.physicsBody?.restitution = 0
        player.physicsBody?.linearDamping = 2
        player.physicsBody?.mass = 0.05
        player.physicsBody?.allowsRotation = false
        
        
        addChild(player)
    }
    
    // Add boundaries to the scene
    func addBoundries() {
        
        // Intialize edge nodes
        let leftEdge = SKNode()
        let rightEdge = SKNode()
        let mover = SKNode()
        
        
        // Position & name the screen edges
        leftEdge.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: 0,y: -kEDGE_EXTENSION_LENGTH), toPoint: CGPoint(x:0, y: self.frame.height + kEDGE_EXTENSION_LENGTH))
        leftEdge.name = "BOUNDARY"
        rightEdge.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: self.frame.width,y: -kEDGE_EXTENSION_LENGTH), toPoint: CGPoint(x:self.frame.width, y: self.frame.height + kEDGE_EXTENSION_LENGTH))
        rightEdge.name = "BOUNDARY"
        
        mover.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: 0, y: self.frame.height / 2), toPoint: CGPoint(x: self.frame.width, y: self.frame.height / 2 ))
        mover.name = "MOVER"
        
        // Add edges to scene
        addChild(leftEdge)
        addChild(rightEdge)
        addChild(mover)
    }
    
    // Add a new level to the scene
    func addLevel(height: CGFloat) {
        var colorOfLevel = UIColor.blackColor()
        numLevels += 1
        
        switch ((numLevels / 5) % 4) {
            case 0: colorOfLevel = LevelColors.Green; break
            case 1: colorOfLevel = LevelColors.Blue; break
            case 2: colorOfLevel = LevelColors.Yellow; break
            case 3: colorOfLevel = LevelColors.Red; break
            default: break;
        }
        
        let level = MGLevel(scene: self, height: height, color: colorOfLevel)
        levels.append(level)
    }
}
