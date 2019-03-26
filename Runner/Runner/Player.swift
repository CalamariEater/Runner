//
//  Player.swift
//  Runner
//
//  Created by Kevin John Bulosan on 4/13/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import GameplayKit
import SpriteKit

class Player: SKSpriteNode {
    
    let imageName = "placeholder_player.png"
    let friction: CGFloat = 0.2
    let linearDamping: CGFloat = 0.1
    let restitution: CGFloat = 0.0
    
    // Animation Test
    let playerWalkAtlas = SKTextureAtlas(named: "playerWalk.atlas")
    var walkFrames = [SKTexture]()
    
    
    /*
    let bodyOffset: CGFloat = 10
    var rightBody: SKPhysicsBody = SKPhysicsBody()
    let rightWidth: CGFloat = 10
    
    var topBody: SKPhysicsBody = SKPhysicsBody()
    let topHeight: CGFloat = 10
    
    var baseBody: SKPhysicsBody = SKPhysicsBody()
    */
    
    
    var down: CGPoint = CGPoint(x: 0, y: 0)
    var down2: CGPoint = CGPoint(x: 0, y: 0)
    
    var up: CGPoint = CGPoint(x: 0, y: 0)
    var up2: CGPoint = CGPoint(x: 0, y: 0)
    
    //var left: CGPoint = CGPoint(x: 0, y: 0)
    //var left2: CGPoint = CGPoint(x: 0, y: 0)
    
    var right: CGPoint = CGPoint(x: 0, y: 0)
    var right2: CGPoint = CGPoint(x: 0, y: 0)
    
    
    init(posX: CGFloat, posY: CGFloat) {
        //let texture = SKTexture(imageNamed: imageName)
        //let textureSize = CGSize(width: texture.size().width/2, height: texture.size().height/2)
        
        
        
        /*
        self.baseBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.rightBody = SKPhysicsBody(rectangleOf: CGSize(width:rightWidth, height: super.frame.height), center: CGPoint(x: 0, y: 0))
        self.topBody = SKPhysicsBody(rectangleOf: CGSize(width: super.frame.width, height: topHeight ), center: CGPoint(x: 0, y: 100000))
        
        //super.physicsBody = SKPhysicsBody(bodies: [base,self.rightBody,self.topBody])
        //super.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        // baseBody
        self.baseBody.isDynamic = true
        self.baseBody.affectedByGravity = true
        self.baseBody.friction = friction
        self.baseBody.linearDamping = linearDamping
        self.baseBody.restitution = restitution
        self.baseBody.allowsRotation = false
        */
        
        // Animation Test
        let numImages = playerWalkAtlas.textureNames.count
        
        for i in 1...numImages {
            walkFrames.append(playerWalkAtlas.textureNamed("playerWalk\(i).png"))
        }
        
        /*
        while i <= numImages {
            let playerTextureName = "playerWalk\(i).png"
            walkFrames.append(playerWalkAtlas.textureNamed(playerTextureName))
            i += 1
        }*/
        
        let firstFrame = walkFrames[0]
        
        super.init(texture: firstFrame, color: SKColor.clear, size: firstFrame.size())
        
        super.physicsBody = SKPhysicsBody(rectangleOf: firstFrame.size())
        
        
       // super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        //super.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        super.physicsBody?.isDynamic = true
        super.physicsBody?.affectedByGravity = true
        super.physicsBody?.friction = friction
        super.physicsBody?.linearDamping = linearDamping
        super.physicsBody?.restitution = restitution
        super.physicsBody?.allowsRotation = false
        
        super.position = CGPoint(x: posX, y: posY)
        
        //print(super.frame.origin.x)
        //print(super.frame.origin.y)
        
        // Start animation/stop
        let walkAnimation = SKAction.animate(with: walkFrames, timePerFrame: 0.1, resize: false, restore: false)
        self.run(SKAction.repeatForever(walkAnimation), withKey: "walkingPlayer")
        walkStop()
        
        getPoints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func sideCollided(contactPoint: SKPhysicsContact) -> CGPoint {
        getPoints()
        
        let downDist = getDistance(p1: contactPoint.contactPoint, p2: self.down)
        //let down2Dist = getDistance(p1: contactPoint.contactPoint, p2: self.down2)
        
        let upDist = getDistance(p1: contactPoint.contactPoint, p2: self.up)
        let up2Dist = getDistance(p1: contactPoint.contactPoint, p2: self.up2)
        
        //let leftDist = getDistance(p1: contactPoint.contactPoint, p2: self.left)
        //let left2Dist = getDistance(p1: contactPoint.contactPoint, p2: self.left2)
        
        let rightDist = getDistance(p1: contactPoint.contactPoint, p2: self.right)
        let right2Dist = getDistance(p1: contactPoint.contactPoint, p2: self.right2)
        
        let distances = [downDist, upDist, up2Dist, rightDist, right2Dist]
        
        let min = distances.min()!
        
        switch min {
        case downDist:
            print("DOWN")
            return self.down
        //case down2Dist:
            //print("DOWN")
            //return self.down
            
        case upDist:
            print("UP")
            return self.up
        case up2Dist:
            print("UP")
            return self.up
            
        case rightDist:
            print("RIGHT")
            return self.right
        case right2Dist:
            print("RIGHT")
            return self.right
            
        default:
            break
        }
        return CGPoint(x: 0, y: 0)
    }
    
    // Animation test
    func walkStart() {
        // walkingPlayer
        if let firsRun = action(forKey: "walkingPlayer") {
            firsRun.speed = 1.0
        }
    }
    
    func walkStop() {
        // walkingPlayer
        if let firsRun = action(forKey: "walkingPlayer") {
            firsRun.speed = 0.0
        }
    }
    
    func getPoints() {
        let fourthHeight = super.frame.height/4
        let fourthWidth = super.frame.width/4
        
        //let halftHeight = super.frame.height/2
        let halfWidth = super.frame.height/2
        
        self.down = CGPoint(x: super.frame.origin.x + (super.frame.width - halfWidth), y: super.frame.origin.y)
        //self.down2 = CGPoint(x: super.frame.origin.x + fourthWidth, y: super.frame.origin.y - super.frame.height/2)
        
        self.up = CGPoint(x: super.frame.origin.x + (super.frame.width - fourthWidth), y: super.frame.origin.y + super.frame.size.height)
        self.up2 = CGPoint(x: super.frame.origin.x + fourthWidth, y: super.frame.origin.y + super.frame.size.height)
        
        //self.left = CGPoint(x: super.frame.origin.x - super.frame.width, y: super.frame.origin.y + (super.frame.height - fourthHeight))
        //self.left2 = CGPoint(x: super.frame.origin.x - super.frame.width, y: super.frame.origin.y + fourthHeight)
        
        self.right = CGPoint(x: super.frame.origin.x + super.frame.size.width, y: super.frame.origin.y + (super.frame.height - fourthHeight))
        self.right2 = CGPoint(x: super.frame.origin.x + super.frame.size.width, y: super.frame.origin.y + fourthHeight)
    }
 
    
    
}

// Helper function
func getDistance(p1: CGPoint, p2: CGPoint) -> CGFloat {
    let xDist = (p2.x - p1.x)
    let yDist = (p2.y - p1.y)
    return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
}
