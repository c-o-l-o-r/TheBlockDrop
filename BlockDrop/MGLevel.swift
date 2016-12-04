//
//  Level.swift
//  BlockDrop
//
//  Created by Matt Garnett on 8/2/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import SpriteKit

class MGLevel {
    fileprivate let row : MGRow!
    fileprivate let obstacle1 : SKSpriteNode!
    fileprivate let obstacle2 : SKSpriteNode!
    fileprivate var hasBeenCompleted = false
    
    init(scene: SKScene,height: CGFloat, color: UIColor) {
        row = MGRow(scene: scene, height: height, color: color)
        
        let marginFromTop = (scene.frame.height / 2) * 0.3
        let randomXPos1 = CGFloat(UInt32(scene.frame.height / 6) + arc4random_uniform(UInt32(scene.frame.width * 0.3)))
        let randomYPos1 = CGFloat(UInt32(marginFromTop) + arc4random_uniform(UInt32((scene.frame.height / 2) * 0.2)))
        let randomXPos2 = CGFloat(UInt32(scene.frame.height / 6) + arc4random_uniform(UInt32(scene.frame.width * 0.3)))
        
        
        obstacle1 = SKSpriteNode(color: color, size: CGSize(width: 25, height: 25))
        obstacle1.position = CGPoint(x: randomXPos1, y: height - randomYPos1)
        
        obstacle2 = SKSpriteNode(color: color, size: CGSize(width: 25, height: 25))
        obstacle2.position = CGPoint(x: randomXPos2, y: height - randomYPos1 - scene.frame.height * 0.2)
        
        obstacle1.physicsBody = SKPhysicsBody(rectangleOf: obstacle1.size)
        obstacle1.physicsBody?.isDynamic = false
        obstacle1.physicsBody?.categoryBitMask = CollisionMask.Obstacle
        obstacle1.physicsBody?.contactTestBitMask = CollisionMask.Player
        
        obstacle2.physicsBody = SKPhysicsBody(rectangleOf: obstacle2.size)
        obstacle2.physicsBody?.isDynamic = false
        obstacle2.physicsBody?.categoryBitMask = CollisionMask.Obstacle
        obstacle2.physicsBody?.contactTestBitMask = CollisionMask.Player
        
        
        scene.addChild(obstacle1)
        scene.addChild(obstacle2)
    }
    
    // Remove all nodes from their parents so they can be deallocated
    func removeNodesFromParent() {
        obstacle1.removeFromParent()
        obstacle2.removeFromParent()
        row.removeNodesFromParent()
    }
    
    // Used to move the level up in the view, giving the appearence of it moving
    func moveUpBy(_ amt: CGFloat) {
        
        row.moveUpBy(amt)
        
        obstacle1.position.y += amt
        obstacle2.position.y += amt
    }
    
    // Return the levels currennt heigh (anchored at the initial row)
    func getCurrentHeight() -> CGFloat {
        return row.getCurrentHeight()
    }
    
    // Return whether the level has been passed
    func hasLevelBeenCompleted() -> Bool {
        return hasBeenCompleted
    }
    
    // Set that the level has been completed
    func completeLevel() {
        hasBeenCompleted = true
    }
}
