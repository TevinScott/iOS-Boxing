//
//  GameScene.swift
//  Ball Physics
//
//  Created by Tevin Scott on 12/22/16.
//  Copyright © 2016 Tevin Scott. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //LEFT GLOVE VARIABLES
    var leftGlove : SKSpriteNode?
    var leftGloveSelected:SKSpriteNode?
    var leftGloveHistory:[TouchInfo]?
    var leftGloveMade = false;
    var leftCircle: CAShapeLayer?
    var currentTouchForLeft : UITouch?
    let leftGloveRestPosition = SKFieldNode.radialGravityField()
    var leftGloveRestPoint: CGPoint?
    var leftTouchInprogress: Bool = false;
    var playerSprite : SKSpriteNode?
    var rightGlove : SKSpriteNode?
    var rightGloveSelected:SKSpriteNode?
    var rightGloveHistory:[TouchInfo]?
    var rightGloveMade = false;
    var rightCircle: CAShapeLayer?
    var currentTouchForRight : UITouch?
    let rightGloveRestPosition = SKFieldNode.radialGravityField()
    var rightGloveRestPoint: CGPoint?
    var rightTouchInprogress: Bool = false;
    let background = SKSpriteNode(imageNamed: "background")
    let opponentSprite = SKSpriteNode(imageNamed: "opponent")
    struct TouchInfo {
        var location:CGPoint
        var time:TimeInterval
    }

    override func didMove(to view: SKView) {
        leftGloveRestPoint = CGPoint(x: self.size.width / 4, y: self.size.height / 2)
        rightGloveRestPoint = CGPoint(x: (self.size.width/4 * 3), y: self.size.height / 2)
        print(self.frame.size)
        addScenePhysics();
        addBackGround()
        createGloves()
        addOpponent()
        createPlayer()
        let gravityField1Category = 0x1<<0
        leftCircle = drawDot(location: leftGloveRestPoint!)
        view.layer.addSublayer(leftCircle!)
        leftGloveRestPosition.isEnabled = false;
        leftGloveRestPosition.position = leftGloveRestPoint!
        leftGloveRestPosition.strength = 4;
        let velocity1 = CGVector(dx: 0, dy: 0)
        leftGloveSelected?.physicsBody?.affectedByGravity = true;
        leftGloveSelected?.physicsBody?.velocity = velocity1
        leftGloveRestPosition.categoryBitMask = UInt32(gravityField1Category)
        leftGlove?.physicsBody?.fieldBitMask = UInt32(gravityField1Category)
        addChild(leftGloveRestPosition)
        
        
        
        let gravityField2Category = 0x1<<1
        rightCircle = drawDot(location: rightGloveRestPoint!)
        view.layer.addSublayer(rightCircle!)
        rightGloveRestPosition.isEnabled = false;
        rightGloveRestPosition.position = rightGloveRestPoint!
        rightGloveRestPosition.strength = 4;
        let velocity2 = CGVector(dx: 0, dy: 0)
        rightGloveSelected?.physicsBody?.affectedByGravity = true;
        rightGloveSelected?.physicsBody?.velocity = velocity2
        rightGloveRestPosition.categoryBitMask = UInt32(gravityField2Category)
        rightGlove?.physicsBody?.fieldBitMask = UInt32(gravityField2Category)
        addChild(rightGloveRestPosition)
        
        
        
    }
    
    private func addBackGround(){
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = -30
        addChild(background)
        
    }
    private func addOpponent(){
        opponentSprite.alpha = 1
        opponentSprite.setScale(1)
        let halfwayPoint : CGFloat = ((leftGlove?.position.x)! + (rightGlove?.position.x)!)/2
        opponentSprite.position = CGPoint(x: halfwayPoint, y: 170)
        opponentSprite.zPosition = -20
        opponentSprite.isUserInteractionEnabled = false;
        opponentSprite.name = "playerNode"
        self.addChild(opponentSprite)

    }
    private func createPlayer(){
        playerSprite = SKSpriteNode(imageNamed: "player");
        playerSprite?.alpha = 0.6
        playerSprite?.setScale(1)
        let halfwayPoint : CGFloat = ((leftGlove?.position.x)! + (rightGlove?.position.x)!)/2
        playerSprite?.position = CGPoint(x: halfwayPoint, y: 150)
        playerSprite?.zPosition = 10
        playerSprite?.isUserInteractionEnabled = false;
        playerSprite?.name = "playerNode"
        self.addChild(playerSprite!)
    }
    private func createGloves(){
            leftGlove = SKSpriteNode(imageNamed:"left glove")
            leftGlove?.setScale(1)
            leftGlove?.position = leftGloveRestPoint!
            leftGlove?.zPosition = -10
            leftGlove?.physicsBody = SKPhysicsBody(texture: (leftGlove?.texture)!, size: (leftGlove?.size)!)
            leftGlove?.physicsBody?.affectedByGravity = true
            leftGlove?.physicsBody?.restitution = 0
            leftGlove?.physicsBody?.linearDamping = 0
            leftGlove?.name = "LeftGlove"
            leftGloveMade = true;
            self.addChild(leftGlove!)
            rightGlove = SKSpriteNode(imageNamed: "right glove")
            rightGlove?.setScale(1)
            rightGlove?.position = rightGloveRestPoint!
            rightGlove?.zPosition = -10
            rightGlove?.physicsBody = SKPhysicsBody(texture: (rightGlove?.texture)!, size: (rightGlove?.size)!)
            rightGlove?.physicsBody?.affectedByGravity = true
            rightGlove?.physicsBody?.restitution = 0
            rightGlove?.physicsBody?.linearDamping = 0
            rightGlove?.name = "rightGlove"
            self.addChild(rightGlove!)
            rightGloveMade = true;
    
    }
    private func drawDot(location: CGPoint) -> CAShapeLayer{
        let circlePath = UIBezierPath(arcCenter: location, radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let outputCircle = CAShapeLayer()
        outputCircle.path = circlePath.cgPath
        
        //change the fill color
        outputCircle.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        outputCircle.strokeColor = UIColor.red.cgColor
        //you can change the line width
        outputCircle.lineWidth = 3.0
        return outputCircle
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            print(nodes)
            for node in nodes {
                if (node.name == "LeftGlove") {
                    leftTouchInprogress = true;
                    leftGloveRestPosition.isEnabled = false;
                    currentTouchForLeft = touch
                    // Step 1
                    leftGloveSelected = node as? SKSpriteNode;
                    // Stop the sprite
                    leftGloveSelected?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    // Step 2: save information about the touch
                    leftGloveHistory = [TouchInfo(location:location, time:touch.timestamp)]
                }
                if (node.name == "rightGlove") {
                    rightTouchInprogress = true;
                    rightGloveRestPosition.isEnabled = false;
                    currentTouchForRight = touch
                    // Step 1
                    rightGloveSelected = node as? SKSpriteNode;
                    // Stop the sprite
                    rightGloveSelected?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    // Step 2: save information about the touch
                    rightGloveHistory = [TouchInfo(location:location, time:touch.timestamp)]
                }
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if (leftGloveSelected?.name == "LeftGlove") {
                let leftGloveLocation = currentTouchForLeft?.location(in: self)
                let rise = (leftGloveLocation?.y)! - (leftGloveHistory?.first?.location.y)!
                let run = (leftGloveLocation?.x)! - (leftGloveHistory?.first?.location.x)!
                leftGloveSelected?.zRotation = atan(rise/run) - 89
                // Step 1. update sprite's position
                leftGloveSelected?.position = leftGloveLocation!
                // Step 2. save touch data at index 0
                leftGloveHistory?.insert(TouchInfo(location:leftGloveLocation!, time:(touch.timestamp)),at:0)
                leftGloveSelected?.physicsBody?.affectedByGravity = false;
            }
            if (rightGloveSelected?.name == "rightGlove") {
                let rightGloveLocation = currentTouchForRight?.location(in: self)
                let rise = (rightGloveLocation?.y)! - (rightGloveHistory?.first?.location.y)!
                let run = (rightGloveLocation?.x)! - (rightGloveHistory?.first?.location.x)!
                rightGloveSelected?.zRotation = atan(rise/run) + 89
                // Step 1. update sprite's position
                rightGloveSelected?.position = rightGloveLocation!
                // Step 2. save touch data at index 0
                rightGloveHistory?.insert(TouchInfo(location:rightGloveLocation!, time:(touch.timestamp)),at:0)
                rightGloveSelected?.physicsBody?.affectedByGravity = false;
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (leftGloveSelected != nil && leftGloveHistory != nil && leftGloveHistory!.count > 1) {
            leftGloveRestPosition.isEnabled = true;
            var vx:CGFloat = 0.0
            var vy:CGFloat = 0.0
            var previousTouchInfo:TouchInfo?
            // Adjust this value as needed
            // Loop over touch history
            for index in 1...(leftGloveHistory?.count)! - 1 {
                let touchInfo = leftGloveHistory![index]
                let location = touchInfo.location
                if let previousLocation = previousTouchInfo?.location {
                    // Step 1
                    let dx = location.x - previousLocation.x
                    let dy = location.y - previousLocation.y
                    // Step 2
                    let dt = CGFloat(touchInfo.time - previousTouchInfo!.time)
                    // Step 3
                    vx += dx / dt
                    vy += dy / dt
                }
                previousTouchInfo = touchInfo
            }
            leftTouchInprogress = false;
            // Step 4
            /* CONTROLS MOMENTUM AFTER PLAYER LETS GO OF GLOVE
            let maxIterations = 3
            let numElts:Int = min(leftGloveHistory!.count, maxIterations)
            let count = CGFloat(numElts-1)
            let velocity = CGVector(dx: (vx/count)/4, dy: (vy/count)/4)
            leftGloveSelected?.physicsBody?.affectedByGravity = true;
            leftGloveSelected?.physicsBody?.velocity = velocity
            */
            // Step 5
            leftGloveSelected = nil
            leftGloveHistory = nil
        }
        if (rightGloveSelected != nil && rightGloveHistory != nil && rightGloveHistory!.count > 1) {
            rightGloveRestPosition.isEnabled = true;
            var vx:CGFloat = 0.0
            var vy:CGFloat = 0.0
            var previousTouchInfo:TouchInfo?
            // Adjust this value as needed
            let maxIterations = 3
            let numElts:Int = min(rightGloveHistory!.count, maxIterations)
            // Loop over touch history
            for index in 1...(rightGloveHistory?.count)! - 1 {
                let touchInfo = rightGloveHistory![index]
                let location = touchInfo.location
                if let previousLocation = previousTouchInfo?.location {
                    // Step 1
                    let dx = location.x - previousLocation.x
                    let dy = location.y - previousLocation.y
                    // Step 2
                    let dt = CGFloat(touchInfo.time - previousTouchInfo!.time)
                    // Step 3
                    vx += dx / dt
                    vy += dy / dt
                }
                previousTouchInfo = touchInfo
            }
            rightTouchInprogress = false;
            print("numElts!!!! \(numElts)")
            // Step 4
            /*CONTROLS MOMENTUM AFTER PLAYER LETS GO OF GLOVE
            let count = CGFloat(numElts-1)
            let velocity = CGVector(dx: (vx/count)/4, dy: (vy/count)/4)
            rightGloveSelected?.physicsBody?.affectedByGravity = true;
            rightGloveSelected?.physicsBody?.velocity = velocity
            */
            // Step 5
            rightGloveSelected = nil
            rightGloveHistory = nil
        }
    }
    private func addScenePhysics(){
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        sceneBody.friction = 0;
        self.physicsBody = sceneBody
    }
    override func update(_ currentTime: CFTimeInterval) {
        let StoppingVelocity = CGVector(dx: 0, dy: 0)
        //LEFT GLOVE
        if ((leftGloveRestPosition.frame).intersects((leftGlove?.frame)!)){
            leftGloveRestPosition.isEnabled = false;
            leftGlove?.physicsBody?.velocity = StoppingVelocity
        }
        //LEFT GLOVE FRAME RESTRICTIONS
        if(leftTouchInprogress && (leftGlove?.position.x)! + 125 > (rightGlove?.position.x)!){
            print("intersected")
            leftGlove?.position.x = (rightGlove?.position.x)! - 125
        }
        if((leftGlove?.position.x)! < CGFloat(20)){
            leftGlove?.position.x = 50
        }
        if((leftGlove?.position.y)! < CGFloat(50)){
            leftGlove?.position.y = 60
        }
        if((leftGlove?.position.y)! > frame.size.height - 50){
            leftGlove?.position.y = frame.size.height - 50
        }
        //RIGHT GLOVE
        if ((rightGloveRestPosition.frame).intersects((rightGlove?.frame)!)){
            rightGloveRestPosition.isEnabled = false;
            rightGlove?.physicsBody?.velocity = StoppingVelocity
        }
        //RIGHT GLOVE FRAME RESTRICTIONS
        //need to change based on which glove is selected
        if(leftTouchInprogress && (leftGlove?.position.x)! + 125 > (rightGlove?.position.x)!){
            print("intersected")
            rightGlove?.position.x = (leftGlove?.position.x)! + 125
        }
        if((rightGlove?.position.x)! > frame.size.width - 50){
            rightGlove?.position.x = frame.size.width - 50
        }
        if((rightGlove?.position.y)! < CGFloat(50)){
            rightGlove?.position.y = 60
        }
        if((rightGlove?.position.y)! > frame.size.height - 50){
            rightGlove?.position.y = frame.size.height - 50
        }
        //both
        if(!leftTouchInprogress && !rightTouchInprogress){
            leftGlove?.zRotation = 0
            leftGlove?.physicsBody?.angularVelocity = 0;
            rightGlove?.zRotation = 0
            rightGlove?.physicsBody?.angularVelocity = 0;
        }



    }
}
