//
//  GameScene.swift
//  geoDash
//
//  Created by Aldin Fajic on 7/13/16.
//  Copyright (c) 2016 Aldin Fajic. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var referenceTimer = NSTimer()
    
    var Player = SKSpriteNode()
    
    var isJumping = Bool()
    var isTouching = Bool()
    
    let obstacleArray = ["Obstacle1", "Obstacle2", "Obstacle3", "Obstacle4"]
    let lightColors = [UIColor.yellowColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.cyanColor(), UIColor.orangeColor(), UIColor.purpleColor(), UIColor.whiteColor(), UIColor.magentaColor()]
    
    var score = Int()
    var highScore = Int()
    var scoreTimer = NSTimer()
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var didTouchBoundries = false
    var ogPlayerPositionX = CGFloat()
    
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
        
        // scene will handle all the contacts within project
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 3)
        // get the player from the scene
        Player = scene?.childNodeWithName("Person") as! SKSpriteNode
        // can collide with ground and obstacles
        Player.physicsBody?.collisionBitMask = 1 | 3
        Player.physicsBody?.contactTestBitMask = 1 | 3
        Player.alpha = 0.1
        ogPlayerPositionX = Player.position.x
        
        referenceTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(GameScene.pickReference), userInfo: nil, repeats: true)
        
        scoreTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameScene.addScore), userInfo: nil, repeats: true)
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight))
        
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    }
    
    // teleport player. Turn off collision
    func swipedRight(sender:UISwipeGestureRecognizer){
        // Player.physicsBody?.categoryBitMask = 999999
        Player.physicsBody?.dynamic = false
        
        let effect = SKEmitterNode(fileNamed: "MagitTest.sks")
        let light = Player.childNodeWithName("light") as! SKLightNode
        if Player.position.x == ogPlayerPositionX {
            effect?.particleColor = light.lightColor
            effect?.position = Player.position
            addChild(effect!)
        }
        
        Player.position.x = Player.position.x + 450
        
        if sender.state == .Ended {
            Player.physicsBody?.dynamic = true
            
            // move to original x position
            if Player.position.x != ogPlayerPositionX {
                let action = SKAction.moveToX(ogPlayerPositionX, duration: 1.5)
                let fadeAction = SKAction.fadeOutWithDuration(1.5)
                effect?.runAction(fadeAction, completion: { 
                    effect?.removeFromParent()
                })
                Player.runAction(action)
            }
        }
    }
    
    func addScore() {
        score += 1
        if score % 5 == 0 {
            let light = Player.childNodeWithName("light") as! SKLightNode
            let randomNumber = arc4random() % UInt32(lightColors.count)
            light.lightColor = lightColors[Int(randomNumber)]
        }
        scoreLabel.text = "Score : \(score)"
        
        let light = Player.childNodeWithName("light") as! SKLightNode
        // light.falloff = 3
        let currfalloff = light.falloff
        if currfalloff > 1 {
            let newFalloff = currfalloff - 1.5
            light.falloff = newFalloff
        }
        
        
        
        if score > highScore {
            highScore = score
            highScoreLabel.text = "Highscore : \(highScore)"
            let userDefaults = NSUserDefaults.standardUserDefaults()
            // set new high score
            userDefaults.setInteger(highScore, forKey: "highScore")
        }
    }
    
    func jump() {
        // only jump if not currently jumping and if player touches screen
        if isTouching == true {
            
            Player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -200))
            isJumping = true
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        
        // detect player & obstacles contact
        if bodyA?.physicsBody?.categoryBitMask == 2 && bodyB?.physicsBody?.categoryBitMask == 3 {
            pauseAndRemoveNodes()
        }
        else if bodyA?.physicsBody?.categoryBitMask == 3 && bodyB?.physicsBody?.categoryBitMask == 2 {
            pauseAndRemoveNodes()
        }
            
            // detect player & enemy contact
        else if bodyA?.physicsBody?.categoryBitMask == 2 && bodyB?.physicsBody?.categoryBitMask == 4 {
            pauseAndRemoveNodes()
        }
        else if bodyA?.physicsBody?.categoryBitMask == 4 && bodyB?.physicsBody?.categoryBitMask == 2 {
            pauseAndRemoveNodes()
        }
    }
    
    func buildExplosion(spriteToExplode: SKSpriteNode) {
        // get the particle file
        let explosion = SKEmitterNode(fileNamed: "Explosion.sks")
        explosion?.numParticlesToEmit = 200
        explosion?.runAction(SKAction.playSoundFileNamed("Explosion.wav", waitForCompletion: false))
        
        // set position same as node to attach it to
        explosion?.position = spriteToExplode.position
        // remove the affected node
        spriteToExplode.removeFromParent()
        addChild(explosion!)
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.gameOver()
        })
    }
    
    func gameOver() {
        scoreTimer.invalidate()
        // load up the scene again
        let scene = OptionsScene(fileNamed: "OptionsScene")
        let transition = SKTransition.crossFadeWithDuration(0.5)
        // create a new view
        let view = self.view as SKView!
        // fill the whole screen
        scene?.scaleMode = SKSceneScaleMode.AspectFill
        // load scene onto view
        view.presentScene(scene!, transition: transition)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // detect touching action
        isTouching = true
        
        for touch in touches {
            // get touch location
            let location = touch.locationInNode(self)
            // get node being touched
            let node = self.nodeAtPoint(location)
            // check if retry button is clicked
            if node.name == "retryBtn" {
                restartScene()
            }
        }
        
        let light = Player.childNodeWithName("light") as! SKLightNode
        let currfalloff = light.falloff
        let newFalloff = currfalloff + 1
        light.falloff = newFalloff
        
        
        jump()
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _ = Player.childNodeWithName("light") as! SKLightNode
        // light.falloff = 3
        isTouching = false
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        if didTouchBoundries == false {
            if Player.position.y <= 0 {
                pauseAndRemoveNodes()
                didTouchBoundries = true
            }
            else if Player.position.y >= self.frame.size.height {
                pauseAndRemoveNodes()
                didTouchBoundries = true
            }
        }
    }
    
    func pauseAndRemoveNodes() {
        for node in self.children {
            node.removeAllActions()
        }
        referenceTimer.invalidate()
        buildExplosion(Player)
    }
    
    func pickReference() {
        let randomNumber = arc4random() % UInt32(obstacleArray.count)
        addReference(obstacleArray[Int(randomNumber)])
    }
    
    func addReference(obstacleName: String) {
        let reference = NSBundle.mainBundle().pathForResource(obstacleName, ofType: "sks")
        let referenceNode = SKReferenceNode(URL: NSURL(fileURLWithPath: reference!))
        
        referenceNode.position = CGPoint(x: (self.scene?.size.width)!, y: 0)
        self.addChild(referenceNode)
        
        // move the object
        let moveAction = SKAction.moveToX(0 - referenceNode.scene!.frame.width, duration: 10.0)
        // remove the object
        let destroyAction = SKAction.removeFromParent()
        
        // animate the node
        referenceNode.runAction(SKAction.sequence([moveAction, destroyAction]))
    }
}
