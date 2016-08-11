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
    
    var rewardsCircle :  SKShapeNode!
    var rewardsCircleLabel : SKLabelNode!
    
    var rewards : SKShapeNode!
    
    var rate = SKShapeNode()
    var shareBtn = SKShapeNode()
    
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
        let backColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
        
        shareBtn = SKShapeNode(circleOfRadius: 100)
        shareBtn.name = "share"
        let shareIcon = SKSpriteNode(imageNamed: "share")
        shareIcon.name = "share"
        shareBtn.fillColor = backColor
        shareBtn.strokeColor = backColor
        shareBtn.position = CGPoint(x: 500, y: 240)
        shareBtn.addChild(shareIcon)
        addChild(shareBtn)
        
        let actionStretchOut = SKAction.scaleTo(1.0, duration: 0.5)
        let actionStretchIn = SKAction.scaleTo(0.8, duration: 0.5)
        let spin = SKAction.rotateByAngle(CGFloat(-M_PI*2), duration: 3.0)
        let sequence = SKAction.sequence([actionStretchOut, actionStretchIn])
        let runForever = SKAction.repeatActionForever(sequence)
        shareBtn.runAction(SKAction.repeatActionForever(spin))
        shareBtn.runAction(runForever)
        
        let leaderBoard = SKShapeNode(circleOfRadius: 100)
        let leaderIcon = SKSpriteNode(imageNamed: "leaderBoard")
        leaderBoard.fillColor = backColor
        leaderBoard.strokeColor = backColor
        leaderBoard.position = CGPoint(x: 830, y: 240)
        leaderBoard.addChild(leaderIcon)
        addChild(leaderBoard)
        
        rate = SKShapeNode(circleOfRadius: 100)
        let rateIcon = SKSpriteNode(imageNamed: "star")
        rate.fillColor = backColor
        rate.strokeColor = backColor
        rate.position = CGPoint(x: 1160, y: 240)
        rate.addChild(rateIcon)
        addChild(rate)
        
        
        rate.setScale(0)
        let action = SKAction.scaleTo(1.0, duration: 1)
        rate.runAction(action)
        
    
        _ = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: #selector(OptionsScene.stretchCircle), userInfo: nil, repeats: true)
        
        rewards = SKShapeNode(circleOfRadius: 100)
        rewards.name = "rewards"
        let rewardsIcon = SKSpriteNode(imageNamed: "reward")
        rewardsIcon.name = "rewards"
        rewards.fillColor = backColor
        rewards.strokeColor = backColor
        rewards.position = CGPoint(x: 1490, y: 240)
        rewards.addChild(rewardsIcon)
        
        if SessionM.sharedInstance().user.unclaimedAchievementCount > 0 {
            rewardsCircle = SKShapeNode(circleOfRadius: 30)
            rewardsCircle.strokeColor = UIColor.redColor()
            rewardsCircle.fillColor = UIColor.redColor()
            rewardsCircle.position = CGPoint(x: -80, y: 70)
            rewardsCircle.name = "rewards"
            rewardsCircleLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
            rewardsCircleLabel.fontColor = UIColor.whiteColor()
            rewardsCircleLabel.position = CGPoint(x: 0, y: -13)
            rewardsCircleLabel.fontSize = 35
            rewardsCircleLabel.name = "rewards"
            rewardsCircleLabel.text = "\(SessionM.sharedInstance().user.unclaimedAchievementCount)"
            rewardsCircle.addChild(rewardsCircleLabel)
            rewards.addChild(rewardsCircle)
        }
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.spinCircle()
        })

        _ = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: #selector(OptionsScene.spinCircle), userInfo: nil, repeats: true)
        
        addChild(rewards)
    }
    
    func stretchCircle() {
        rate.setScale(0)
        let action = SKAction.scaleTo(1.0, duration: 1)
        rate.runAction(action)
    }
    
    func spinCircle() {
        let spin = SKAction.rotateByAngle(CGFloat(-M_PI*2), duration: 5.0)
        rewards.runAction(spin)
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
        for touch: AnyObject in touches {
            // get touch location
            //let location = touch.locationInNode(self)
            // get node being touched
          //  let node = self.nodeAtPoint(location)
            let node = nodeAtPoint(touch.locationInNode(self))
            // check if retry button is clicked
            if node.name == "start" || node.name == "startLabel" || node.name == "tapStart" {
                restartScene()
            }
            else if node.name == "share" {
                share()
            }
            else if (node.name == "rewards" || node == rewards || node == rewardsCircle || node == rewardsCircleLabel) {
                let controller = SMActivityViewController()
                self.appDelegate.window?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
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
    
}
