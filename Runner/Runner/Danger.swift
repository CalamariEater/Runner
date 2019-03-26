//
//  Danger.swift
//  Runner
//
//  Created by Kevin John Bulosan on 3/15/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import GameplayKit
import SpriteKit

// Anything that detriments the player

class Danger: SKSpriteNode {
    
    let theName: String
    var scored: Bool = false
    
    //private var body: SKSpriteNode

    init(point: CGPoint, name: String, physics: Bool) {
        let texture = SKTexture(imageNamed: name)
        //let textureSize = CGSize(width: texture.size().width*3, height: texture.size().height*3)
        self.theName = "danger"
        
        //super.init(texture: texture, color: SKColor.clear, size: textureSize)
        //super.physicsBody = SKPhysicsBody(texture: texture, size: textureSize)
        
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        super.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        if physics {
            
            super.physicsBody?.isDynamic = true
            super.physicsBody?.affectedByGravity = true
        }
        
        super.position = point
        super.name = "danger"
    }
    
    init(point: CGPoint, name: String, theName: String, physics: Bool) {
        let texture = SKTexture(imageNamed: name)
        //let textureSize = CGSize(width: texture.size().width/2, height: texture.size().height/2)
        self.theName = theName
        //super.init(texture: texture, color: SKColor.clear, size: textureSize)
        //super.physicsBody = SKPhysicsBody(texture: texture, size: textureSize)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        super.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        if physics {
            
            super.physicsBody?.isDynamic = true
            super.physicsBody?.affectedByGravity = true
        }
        
        super.position = point
        super.name = "danger"
    }
    
    init(name: String, physics: Bool) {
        let texture = SKTexture(imageNamed: name)
        //let textureSize = CGSize(width: texture.size().width/2, height: texture.size().height/2)
        self.theName = "danger"
        //super.init(texture: texture, color: SKColor.clear, size: textureSize)
        //super.physicsBody = SKPhysicsBody(texture: texture, size: textureSize)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        super.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        if physics {
            
            super.physicsBody?.isDynamic = true
            super.physicsBody?.affectedByGravity = true
        }

        super.name = "danger"
    }
    
    init(name: String, physics: Bool, theName: String) {
        let texture = SKTexture(imageNamed: name)
        //let textureSize = CGSize(width: texture.size().width/2, height: texture.size().height/2)
        self.theName = theName
        
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        super.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        //super.init(texture: texture, color: SKColor.clear, size: textureSize)
        //super.physicsBody = SKPhysicsBody(texture: texture, size: textureSize)
        
        if physics {
            
            super.physicsBody?.isDynamic = true
            super.physicsBody?.affectedByGravity = true
        }
        
        super.name = "danger"
    }

    required init?(coder aDecoder: NSCoder) {
        self.theName = "danger"
        super.init(coder: aDecoder)
    }
    

    
    
    /*
    func update() {
        super.position = CGPoint(x: super.position.x - defaultMovement, y: super.position.y)
    }
    
    func physicsUpdate() {
        super.physicsBody?.applyImpulse(defaultMovementPhys)
    }
    */
}
