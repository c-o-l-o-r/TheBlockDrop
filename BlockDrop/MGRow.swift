//
//  Row.swift
//  BlockDrop
//
//  Created by Matt Garnett on 8/2/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import SpriteKit

class MGRow {
    
    fileprivate var left = SKSpriteNode()
    fileprivate var right = SKSpriteNode()
    
    init(scene: SKScene, height: CGFloat, color: UIColor) {
        
        let framefull = UInt32(scene.frame.width)
        let random = arc4random_uniform(UInt32(scene.frame.width * 0.4))
        let leftSize = Int(framefull / 8 + random)
        let rightSize = Int(scene.frame.width) - leftSize - kHOLE_SIZE
        
        left = SKSpriteNode(color: color, size: CGSize(width:leftSize, height: 35))
        right = SKSpriteNode(color: color, size: CGSize(width: rightSize, height: 35))
        left.position = CGPoint(x: CGFloat(leftSize / 2), y: height)
        right.position = CGPoint(x: CGFloat(leftSize + kHOLE_SIZE + rightSize / 2), y: height)
        
        left.physicsBody = SKPhysicsBody(rectangleOf: left.size)
        left.physicsBody?.isDynamic = false
        left.physicsBody?.categoryBitMask = CollisionMask.Obstacle
        left.physicsBody?.contactTestBitMask = CollisionMask.Player
        
        right.physicsBody = SKPhysicsBody(rectangleOf: right.size)
        right.physicsBody?.isDynamic = false
        right.physicsBody?.categoryBitMask = CollisionMask.Obstacle
        right.physicsBody?.contactTestBitMask = CollisionMask.Player
        
        
        scene.addChild(left)
        scene.addChild(right)

    }
    
    func removeNodesFromParent() {
        right.removeFromParent()
        left.removeFromParent()
    }
    
    func moveUpBy(_ amt: CGFloat) {
        
        left.position.y += amt
        right.position.y += amt
    }
    
    func getCurrentHeight() -> CGFloat {
        return left.position.y
    }
    
    deinit { print("Row has been deallocated") }
        
    
}
