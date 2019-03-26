//
//  PlatformLong.swift
//  Runner
//
//  Created by Kevin John Bulosan on 4/7/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlatformLong: Danger {
    private var imageName: String = "platformLong"
    private var imageName1: String = "placeholder_platform3"
    private var yOffset: CGFloat = 10.0
    private let obName: String = "platformLong"
    
    // Default init
    init(point: CGPoint, categoryBitMask: UInt32, collisionBitMask: UInt32, contactTestBitMask: UInt32){
        super.init(name: imageName, physics: false, theName: obName)
        print("PlatformLong: width - \(super.frame.width) height - \(super.frame.height)")
        
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func resolve(spwnHeight: Int, spwnPoint: CGPoint, previousDanger: String, catBitMask: UInt32, colBitMask: UInt32, testBitMask: UInt32) -> Danger {
        if spwnHeight == 0 && previousDanger == "" { // Nothing to resolve atm
            // Return a different obstacle to spawn
            let resolved = PlatformLong(point: spwnPoint, categoryBitMask: catBitMask, collisionBitMask: colBitMask, contactTestBitMask: testBitMask)
            return resolved
        }
        
        // All good ~ return original obstacle
        return self
    }
}
