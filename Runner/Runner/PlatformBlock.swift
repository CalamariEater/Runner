//
//  PlatformBlock.swift
//  Runner
//
//  Created by Kevin John Bulosan on 4/7/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlatformBlock: Danger {
    private var imageName: String = "platformBlock"
    private var imageName1: String = "placeholder_platform2"
    private var yOffset: CGFloat = 10.0
    private let obName: String = "platformBlock"
    
    var leftSide = SKPhysicsBody()
    
    // Default init
    init(point: CGPoint, categoryBitMask: UInt32, collisionBitMask: UInt32, contactTestBitMask: UInt32){
        
        super.init(name: imageName, physics: false, theName: obName)
        print("PlatformBlock: width - \(super.frame.width) height - \(super.frame.height)")
        
        self.leftSide = SKPhysicsBody(edgeFrom: CGPoint(x: super.frame.minX - 50, y: super.frame.minY), to: CGPoint(x: super.frame.minX - 50, y: super.frame.maxY))
        self.leftSide.pinned = true
        self.leftSide.collisionBitMask = collisionBitMask
        self.leftSide.contactTestBitMask = contactTestBitMask
        
        super.position = CGPoint(x: point.x, y: point.y + super.size.height - yOffset)
        
        super.physicsBody?.affectedByGravity = false
        super.physicsBody?.isDynamic = false
        super.physicsBody?.allowsRotation = false
        super.physicsBody?.restitution = 0
        
        super.physicsBody?.categoryBitMask = categoryBitMask
        super.physicsBody?.collisionBitMask = collisionBitMask
        super.physicsBody?.contactTestBitMask = contactTestBitMask
        
        super.name = "obstacle"
    }
    
    init(categoryBitMask: UInt32, collisionBitMask: UInt32, contactTestBitMask: UInt32){
        super.init(name: imageName, physics: false, theName: obName)
        
        self.leftSide = SKPhysicsBody(edgeFrom: CGPoint(x: super.frame.minX - 50, y: super.frame.minY), to: CGPoint(x: super.frame.minX - 50, y: super.frame.maxY))
        
        super.physicsBody?.affectedByGravity = false
        super.physicsBody?.isDynamic = false
        super.physicsBody?.allowsRotation = false
        super.physicsBody?.restitution = 0
        
        super.physicsBody?.categoryBitMask = categoryBitMask
        super.physicsBody?.collisionBitMask = collisionBitMask
        super.physicsBody?.contactTestBitMask = contactTestBitMask
        
        super.name = "obstacle"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func resolve(spwnHeight: Int, spwnPoint: CGPoint, previousDanger: String, catBitMask: UInt32, colBitMask: UInt32, testBitMask: UInt32) -> Danger {
        if spwnHeight == 0 && previousDanger == "" { //TODO: CHECK IF THIS HELPS "platformSmallStairs"
            // Return a different obstacle to spawn
            
            print("RESOLVED")
            
            let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
            switch rando {
            case 0:
                let resolved = PlatformLong(point: spwnPoint, categoryBitMask: catBitMask, collisionBitMask: colBitMask, contactTestBitMask: testBitMask)
                return resolved
            case 1:
                let resolved = PlatformSmall(point: spwnPoint, categoryBitMask: catBitMask, collisionBitMask: colBitMask, contactTestBitMask: testBitMask)
                return resolved
            default:
                break
            }

        }
        // All good ~ return original obstacle
        return self
    }
}
