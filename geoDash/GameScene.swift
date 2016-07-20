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
    
    var obstacleArray = [String]()
    
    override func didMoveToView(view: SKView) {
        // scene will handle all the contacts within project
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -30)
        // get the player from the scene
        Player = scene?.childNodeWithName("Person") as! SKSpriteNode
        // can collide with ground and obstacles
        Player.physicsBody?.collisionBitMask = 1 | 3
        Player.physicsBody?.contactTestBitMask = 1 | 3
        
        referenceTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(GameScene.pickReference), userInfo: nil, repeats: true)
    }
    
    func jump() {
        // only jump if not currently jumping and if player touches screen
        if isTouching == true {
            if isJumping == false {
                Player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 600))
                isJumping = true
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        
        // detect player & ground contact
        if bodyA?.physicsBody?.categoryBitMask == 2 && bodyB?.physicsBody?.categoryBitMask == 1 {
            isJumping = false
            jump()
        }
        else if bodyA?.physicsBody?.categoryBitMask == 1 && bodyB?.physicsBody?.categoryBitMask == 2 {
            isJumping = false
            jump()
        }
        
        // detect player & obstacles contact
        else if bodyA?.physicsBody?.categoryBitMask == 2 && bodyB?.physicsBody?.categoryBitMask == 3 {
            isJumping = false
            jump()
        }
        else if bodyA?.physicsBody?.categoryBitMask == 3 && bodyB?.physicsBody?.categoryBitMask == 2 {
            isJumping = false
            jump()
        }
        
        // detect player & enemy contact
        else if bodyA?.physicsBody?.categoryBitMask == 2 && bodyB?.physicsBody?.categoryBitMask == 4 {
            for node in self.children {
                node.removeAllActions()
            }
            referenceTimer.invalidate()
            buildExplosion(Player)
        }
        else if bodyA?.physicsBody?.categoryBitMask == 4 && bodyB?.physicsBody?.categoryBitMask == 2 {
            for node in self.children {
                node.removeAllActions()
            }
            referenceTimer.invalidate()
            buildExplosion(Player)
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
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // detect touching action
        isTouching = true
        jump()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouching = false
    }
   
    override func update(currentTime: CFTimeInterval) {
 
    }
    
    func pickReference() {
        obstacleArray = ["Obstacle1", "Obstacle2", "Obstacle3"]
        let randomNumber = arc4random() % UInt32(obstacleArray.count)
        addReference(obstacleArray[Int(randomNumber)])
    }
    
    func addReference(obstacleName: String) {
        let reference = NSBundle.mainBundle().pathForResource(obstacleName, ofType: "sks")
        let referenceNode = SKReferenceNode(URL: NSURL(fileURLWithPath: reference!))
        
        referenceNode.position = CGPoint(x: (self.scene?.size.width)!, y: 100)
        self.addChild(referenceNode)
        
        // move the object
        let moveAction = SKAction.moveToX(0 - referenceNode.scene!.frame.width, duration: 10.0)
        // remove the object
        let destroyAction = SKAction.removeFromParent()
        
        // animate the node
        referenceNode.runAction(SKAction.sequence([moveAction, destroyAction]))
        
        
    }
}
