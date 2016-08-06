//
//  OptionsScene.swift
//  geoDash
//
//  Created by Aldin Fajic on 8/6/16.
//  Copyright © 2016 Aldin Fajic. All rights reserved.
//

import SpriteKit

class OptionsScene: SKScene {
    
    var score = Int()
    var highScore = Int()
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var Player = SKSpriteNode()

    override func didMoveToView(view: SKView) {
        // update labels
        highScoreLabel = scene?.childNodeWithName("HighScoreLabel") as! SKLabelNode
        scoreLabel = scene?.childNodeWithName("ScoreLabel") as! SKLabelNode
        
        // get high score
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.integerForKey("highScore") != 0 {
            highScore = userDefaults.integerForKey("highScore")
            highScoreLabel.text = "Highscore : \(highScore)"
        }else {
            highScore = 0
            highScoreLabel.text = "Highscore : \(highScore)"
        }
        
        scoreLabel.text = "Score : \(score)"
        
        
        Player = scene?.childNodeWithName("Person") as! SKSpriteNode
        // can collide with ground and obstacles
        Player.physicsBody?.collisionBitMask = 1 | 3
        Player.physicsBody?.contactTestBitMask = 1 | 3
        Player.alpha = 0.1
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            // get touch location
            let location = touch.locationInNode(self)
            // get node being touched
            let node = self.nodeAtPoint(location)
            // check if retry button is clicked
            if node.name == "start" {
                restartScene()
            }
        }
    }
    
    
    func restartScene() {
        // load up the scene again
        let scene = GameScene(fileNamed: "GameScene")
        // create a transition effect
        let transition = SKTransition.crossFadeWithDuration(0.5)
        // create a new view
        let view = self.view as SKView!
        // fill the whole screen
        scene?.scaleMode = SKSceneScaleMode.AspectFill
        // load scene onto view
        view.presentScene(scene!, transition: transition)
    }

}
