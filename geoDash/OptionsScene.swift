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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var rewardsBox : SKSpriteNode!
    var rewardsCircle: SKShapeNode!
    var rewardsCircleLabel: SKLabelNode!

    override func didMoveToView(view: SKView) {
        // update labels
        createRewardsBox()
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
            if node.name == "start" || node.name == "startLabel" {
                restartScene()
            }
            else if node.name == "share" {
                share()
            }
        }
    }
    
    func share() {
        let url = NSURL(string: "https://itunes.apple.com/us/app/bar-and-balls/id1112039296?ls=1&mt=8")
        let text = "I scored \(score) points in Bar and Balls! Think you can beat me? \(url!)"
        let controller = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        self.appDelegate.window?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success {
               // SessionM.sharedInstance().logAction("share_app")
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
    
    func createRewardsBox() {
        rewardsBox = SKSpriteNode(texture: SKTexture(imageNamed: "reward"))
        //rewardsBox.zPosition = -50
        rewardsBox.size = CGSize(width: 100, height: 100)
        rewardsBox.position = CGPoint(x: self.size.width - 50, y: CGRectGetMinY(frame) + 50)
        rewardsBox.setScale(0)
        let action = SKAction.scaleTo(1.0, duration: 1)
        rewardsBox.runAction(action)
        addChild(rewardsBox)
        
      //  if SessionM.sharedInstance().user.unclaimedAchievementCount > 0 {
            rewardsCircle = SKShapeNode(circleOfRadius: 13)
          //  rewardsCircle.zPosition = 10
            rewardsCircle.strokeColor = UIColor.redColor()
            rewardsCircle.fillColor = UIColor.redColor()
            rewardsCircle.position = CGPoint(x: -20, y: 20)
            rewardsCircleLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
            rewardsCircleLabel.fontColor = UIColor.whiteColor()
            rewardsCircleLabel.position = CGPoint(x: 0, y: -4)
            rewardsCircleLabel.fontSize = 11
           // rewardsCircleLabel.zPosition = 10
            rewardsCircleLabel.name = "rewardscircle"
            rewardsCircleLabel.text = "10"
            
            rewardsCircle.addChild(rewardsCircleLabel)
            
            rewardsBox.addChild(rewardsCircle)
        //}
        
    }

}
