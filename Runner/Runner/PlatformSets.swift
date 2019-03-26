//
//  PlatformSets.swift
//  Runner
//
//  Created by Kevin John Bulosan on 4/7/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import GameplayKit
import SpriteKit

// Small Platform Stairs
class platformSmallStairs {
    let obName: String = "platformSmallStairs"
    
    init(point: CGPoint, fleights: Int, catMask: UInt32, collMask: UInt32, contMask: UInt32, scene: GameScene){
        
        for index in 0...fleights {
            let platform = PlatformSmall(categoryBitMask: catMask, collisionBitMask: collMask, contactTestBitMask: contMask)
            let newLocation = CGPoint(x: point.x + (CGFloat(index) * CGFloat(platform.frame.width)), y: point.y + (CGFloat(index) * CGFloat(platform.frame.height)))
            platform.position = newLocation
            
            scene.addChild(platform)
        }
    }
    
    
}

