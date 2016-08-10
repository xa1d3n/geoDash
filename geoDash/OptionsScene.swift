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
        animateTapLabel()
        
        createButtons()
        // update labels
        //createRewardsBox()
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
    
    func createButtons() {
        let container = childNodeWithName("buttonContainer") as! SKSpriteNode
        let share = SKShapeNode(circleOfRadius: 8)
        share.fillColor = UIColor.yellowColor()
        container.addChild(share)
    }
    
    func animateTapLabel() {
        let tapStartLbl = childNodeWithName("tapStart") as! SKLabelNode
        let fadeOut = SKAction.fadeOutWithDuration(1.0)
        let fadeIn = SKAction.fadeInWithDuration(1.0)
        let sequence = SKAction.sequence([fadeIn, fadeOut])
        let runForever = SKAction.repeatActionForever(sequence)
        tapStartLbl.runAction(runForever)

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
        let cricle = SKShapeNode(circleOfRadius: 300)
        cricle.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        rewardsBox = SKSpriteNode(texture: SKTexture(imageNamed: "play"))
        cricle.fillColor = UIColor.blueColor()
        rewardsBox.size = CGSize(width: 300, height: 300)
       // rewardsBox.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        cricle.addChild(rewardsBox)
        addChild(cricle)
        
    }

}
