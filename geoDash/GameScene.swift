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
        
        referenceTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(GameScene.pickReference), userInfo: nil, repeats: true)
        
        scoreTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameScene.addScore), userInfo: nil, repeats: true)
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
        gameOver()
    }
    
    func gameOver() {
        scoreTimer.invalidate()
        let retryButton = SKSpriteNode(imageNamed: "retry")
        // when deterining touched node
        retryButton.name = "retryBtn"
        // wait 1 second before showing the retry
        let waitDuration = SKAction.waitForDuration(1.0)
        let fadeIn = SKAction.fadeInWithDuration(0.3)
        retryButton.alpha = 0
        retryButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.addChild(retryButton)
        retryButton.runAction(SKAction.sequence([waitDuration,fadeIn]))
        
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
