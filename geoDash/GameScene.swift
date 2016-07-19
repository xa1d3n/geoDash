//
//  GameScene.swift
//  geoDash
//
//  Created by Aldin Fajic on 7/13/16.
//  Copyright (c) 2016 Aldin Fajic. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var referenceTimer = NSTimer()
    
    override func didMoveToView(view: SKView) {
        referenceTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(GameScene.pickReference), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
    }
   
    override func update(currentTime: CFTimeInterval) {
 
    }
    
    func pickReference() {
        addReference("Obstacle1")
    }
    
    func addReference(obstacleName: String) {
        let reference = NSBundle.mainBundle().pathForResource(obstacleName, ofType: "sks")
        let referenceNode = SKReferenceNode(URL: NSURL(fileURLWithPath: reference!))
        
        referenceNode.position = CGPoint(x: (self.scene?.size.width)!, y: 100)
        self.addChild(referenceNode)
        
        // animate the node
        referenceNode.runAction(SKAction.moveToX(0 - referenceNode.scene!.frame.width, duration: 10.0))
        
        
    }
}
