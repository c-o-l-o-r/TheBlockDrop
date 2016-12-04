//
//  GameOverScene.swift
//  BlockDrop
//
//  Created by Matt Garnett on 8/2/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class GameOverScene: SKScene {
    
    private let message = "GAME OVER"
    private let score_message = "Your score:"
    
    var gameOverGraphic : SKSpriteNode!
    var youGotText : SKSpriteNode!
    var playAgainButton : SKSpriteNode!
    var scoresButton : SKSpriteNode!
    var homeButton : SKSpriteNode!
    
    init(size: CGSize, score: Int) {
        super.init(size: size)
        
        self.backgroundColor = SKColor.whiteColor()
        
        // Set up scene
        gameOverGraphic = SKSpriteNode(imageNamed: "gameOverGraphic.png")
        gameOverGraphic.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.69)
        
        youGotText = SKSpriteNode(imageNamed: "youGotText.png")
        youGotText.position = CGPoint(x: self.size.width / 3, y: self.size.height * 0.41)
        
        playAgainButton = SKSpriteNode(imageNamed: "playAgainButton.png")
        playAgainButton.name = "PLAY"
        playAgainButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 4)
        
        scoresButton = SKSpriteNode(imageNamed: "scoresButtonFilled.png")
        scoresButton.name = "SCORES"
        scoresButton.position = CGPoint(x: self.size.width * 0.75, y: self.size.height / 10)
        
        homeButton = SKSpriteNode(imageNamed: "homeButton.png")
        homeButton.name = "HOME"
        homeButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height / 10)
        
        let scoreLabel = SKLabelNode(fontNamed: "comic andy")
        scoreLabel.text = "\(score)"
        scoreLabel.fontColor = .blackColor()
        scoreLabel.fontSize = 120
        scoreLabel.position = CGPoint(x: self.size.width * 0.65, y: self.size.height * 0.38)
        
        // Add children to scene
        addChild(gameOverGraphic)
        addChild(youGotText)
        addChild(scoreLabel)
        addChild(playAgainButton)
        addChild(scoresButton)
        addChild(homeButton)
        
        // Get the users highest local score
        let defaults = NSUserDefaults.standardUserDefaults()
        let highScore = defaults.integerForKey("highScore")
        
        // If the new score is higher than the local high score, upload it to Game Center & update it locally
        if highScore < score {
            defaults.setInteger(score, forKey: "highScore")
            defaults.synchronize()
            sendScoreToGameCenter(score)
        }
    

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "PLAY"
            {
                playAgainButton.runAction(SKAction.scaleTo(0.9, duration: 0.2))
            } else if name == "SCORES" {
                scoresButton.runAction(SKAction.scaleTo(0.9, duration: 0.2))
            } else if name == "HOME" {
                homeButton.runAction(SKAction.scaleTo(0.9, duration: 0.2))
            }
            
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "BG"
            {
                playAgainButton.runAction(SKAction.scaleTo(1.0, duration: 0.15))
                scoresButton.runAction(SKAction.scaleTo(1.0, duration: 0.15))
                homeButton.runAction(SKAction.scaleTo(1.0, duration: 0.15))
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "PLAY"
            {
                playAgainButton.runAction(SKAction.scaleTo(1.0, duration: 0.2))
                let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.3)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
            
            if name == "SCORES"
            {
                scoresButton.runAction(SKAction.scaleTo(1.0, duration: 0.2))
                NSNotificationCenter.defaultCenter().postNotificationName("showLeaderboard", object: nil)

            }
            
            if name == "HOME"
            {
                homeButton.runAction(SKAction.scaleTo(1.0, duration: 0.2))
                let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 0.3)
                let mainMenu = MainMenu(size: self.size)
                self.view?.presentScene(mainMenu, transition: transition)
            }
        }
        
    }
    
    func sendScoreToGameCenter(s: Int) {
        
        let scoreObject = GKScore(leaderboardIdentifier: "block_drop_highscores")
        scoreObject.value = Int64(s)
        GKScore.reportScores([scoreObject]) { (error) -> Void in
            guard error == nil else {
                print("Error in reporting leaderboard scores: \(error)")
                return
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
