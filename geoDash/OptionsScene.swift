//
//  OptionsScene.swift
//  geoDash
//
//  Created by Aldin Fajic on 8/6/16.
//  Copyright © 2016 Aldin Fajic. All rights reserved.
//

import SpriteKit
import GameKit
import StoreKit


class OptionsScene: SKScene, GKGameCenterControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
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
    var products = [SKProduct]()
    
    var videoRefSprite = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        requestProducts()
        authPlayer()
        animateTapLabel()
        
        createButtons()
        // update labels
        //createRewardsBox()
        highScoreLabel = scene?.childNodeWithName("HighScoreLabel") as! SKLabelNode
        highScoreLabel.fontName = "AngryBirds Regular"
        highScoreLabel.fontSize = 50
        scoreLabel = scene?.childNodeWithName("ScoreLabel") as! SKLabelNode
        scoreLabel.fontName = "AngryBirds Regular"
        scoreLabel.fontSize = 50
        
        videoRefSprite = scene?.childNodeWithName("VideoSprite") as! SKSpriteNode
        videoRefSprite.alpha = 0
        
        
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
        
        createVideoBonus()
    }
    
    // dismiss game center
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // authenticate user with game center
    func authPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                
            } else {
                // print(GKLocalPlayer.localPlayer().authenticated)
            }
        }
    }
    
    func createVideoBonus() {
        let backColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
        let video = SKShapeNode(circleOfRadius: 130)
        video.name = "video"
        let videoIcon = SKSpriteNode(imageNamed: "film")
        videoIcon.name = "video"
        videoIcon.position.y = -10
        video.fillColor = backColor
        video.strokeColor = backColor
        video.position = CGPoint(x: videoRefSprite.position.x, y: videoRefSprite.position.y)
        
        let videoLabel = SKLabelNode(fontNamed: "AngryBirds Regular")
        videoLabel.text = "+10"
        videoLabel.name = "video"
        videoLabel.fontSize = 40
        videoLabel.fontColor = UIColor.whiteColor()
        videoLabel.position = CGPoint(x: -40, y: 55)
        
        let swipeIcon = SKSpriteNode(imageNamed: "swipe")
        swipeIcon.name = "video"
        swipeIcon.position = CGPoint(x: 40, y: 69)
        
        video.addChild(videoLabel)
        video.addChild(swipeIcon)
        video.addChild(videoIcon)
        
        let actionStretchOut = SKAction.scaleTo(1.0, duration: 0.5)
        let actionStretchIn = SKAction.scaleTo(0.8, duration: 0.5)
        let sequence = SKAction.sequence([actionStretchOut, actionStretchIn])
        let runForever = SKAction.repeatActionForever(sequence)
        video.runAction(runForever)
        
        
        addChild(video)
    }
    
    func createVideoBonus1() {
        let videoBtn = SKSpriteNode(imageNamed: "film")
        videoBtn.position = CGPoint(x: videoRefSprite.position.x, y: videoRefSprite.position.y)
        addChild(videoBtn)
    }
    
    func createButtons() {
        let backColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
        
        let noAds = SKShapeNode(circleOfRadius: 100)
        noAds.name = "noAds"
        noAds.strokeColor = backColor
        noAds.fillColor = backColor
        noAds.position = CGPoint(x: 200, y: 240)
        let noLbl = SKLabelNode(text: "NO")
        noLbl.fontName = "AngryBirds Regular"
        noLbl.fontSize = 50
        noLbl.position = CGPoint(x: 0, y: 20)
        noLbl.color = UIColor.whiteColor()
        noAds.addChild(noLbl)
        let adsLbl = SKLabelNode(text: "ADS")
        adsLbl.fontName = "AngryBirds Regular"
        adsLbl.fontSize = 50
        adsLbl.position = CGPoint(x: 0, y: -40)
        adsLbl.color = UIColor.whiteColor()
        noAds.addChild(adsLbl)
        adsLbl.name = "noAds"
        noLbl.name = "noAds"
        addChild(noAds)
        
        let restore = SKShapeNode(circleOfRadius:  100)
        restore.name = "restore"
        let restoreIcon = SKSpriteNode(imageNamed: "restore")
        restoreIcon.name = "restore"
        restore.strokeColor = backColor
        restore.fillColor = backColor
        restore.position = CGPoint(x: 500, y: 240)
        restore.addChild(restoreIcon)
        addChild(restore)
        
        shareBtn = SKShapeNode(circleOfRadius: 100)
        shareBtn.name = "share"
        let shareIcon = SKSpriteNode(imageNamed: "share")
        shareIcon.name = "share"
        shareBtn.fillColor = backColor
        shareBtn.strokeColor = backColor
        shareBtn.position = CGPoint(x: 800, y: 240)
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
        leaderBoard.name = "leaderBoard"
        let leaderIcon = SKSpriteNode(imageNamed: "leaderBoard")
        leaderIcon.name = "leaderBoard"
        leaderBoard.fillColor = backColor
        leaderBoard.strokeColor = backColor
        leaderBoard.position = CGPoint(x: 1100, y: 240)
        leaderBoard.addChild(leaderIcon)
        addChild(leaderBoard)
        
        rate = SKShapeNode(circleOfRadius: 100)
        rate.name = "rate"
        let rateIcon = SKSpriteNode(imageNamed: "star")
        rateIcon.name = "rate"
        rate.fillColor = backColor
        rate.strokeColor = backColor
        rate.position = CGPoint(x: 1400, y: 240)
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
        rewards.position = CGPoint(x: 1700, y: 240)
        rewards.addChild(rewardsIcon)
        
        
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
        tapStartLbl.fontName = "AngryBirds Regular"
        let fadeOut = SKAction.fadeOutWithDuration(1.0)
        let fadeIn = SKAction.fadeInWithDuration(1.0)
        let sequence = SKAction.sequence([fadeIn, fadeOut])
        let runForever = SKAction.repeatActionForever(sequence)
        tapStartLbl.runAction(runForever)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
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
            else if (node.name == "leaderBoard") {
                showLeaderBoard()
            }
            else if (node.name == "rate") {
                SessionM.sharedInstance().logAction("rate_app")
                UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/square-lights/id1143377277?ls=1&mt=8")!)
            }
            else if (node.name == "noAds") {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
                
                for product in products {
                    formatter.locale = product.priceLocale
                    if let price = formatter.stringFromNumber(product.price) {
                        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
                        let payment = SKPayment(product: product)
                        SKPaymentQueue.defaultQueue().addPayment(payment)
                    }
                }
            }
            else if (node.name == "restore") {
                restorePurchase()
            }
            else if (node.name == "video") {
                if Chartboost.hasRewardedVideo(CBLocationMainMenu) {
                    Chartboost.showRewardedVideo(CBLocationMainMenu)
                } else {
                    Chartboost.cacheInterstitial(CBLocationMainMenu)
                    Chartboost.showRewardedVideo(CBLocationMainMenu)
                }
                
            }
            
        }
    }
    
    func restorePurchase() {
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    // open game center leaderboard
    func showLeaderBoard() {
        let vc = self.view?.window?.rootViewController
        let gcVc = GKGameCenterViewController()
        
        gcVc.gameCenterDelegate = self
        vc?.presentViewController(gcVc, animated: true, completion: nil)
    }
    
    func share() {
        let url = NSURL(string: "https://itunes.apple.com/us/app/bar-and-balls/id1112039296?ls=1&mt=8")
        let text = "I scored \(score) points in Bar and Balls! Think you can beat me? \(url!)"
        let controller = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        self.appDelegate.window?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success {
                SessionM.sharedInstance().logAction("share_app")
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
    
    // check in app purchase products
    func requestProducts() {
        let ids : Set<String> = [Constants().productId]
        let productsRequest = SKProductsRequest(productIdentifiers: ids)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        products = response.products
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .Purchased:
                // clear the transaction
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                print("Purchased")
                removeAds(transaction.payment.productIdentifier)
                break
            case .Purchasing:
                print("Purchasing")
                break
            case .Failed:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                print("Failed")
                break
            case .Restored:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                removeAds(transaction.payment.productIdentifier)
                print("Restored")
                break
            case .Deferred:
                print("Deferred")
                break
            }
        }
    }
    
    func removeAds(productIdentifier: String) {
        // remove google ads banner
    }
    
}
