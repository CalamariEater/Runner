//
//  PhysicsBasicCals.swift
//  BrickBreakUNLV
//
//  Created by Kevin John Bulosan on 3/3/17.
//  https://www.raywenderlich.com/42699/spritekit-tutorial-for-beginners
//

import GameplayKit

class PhysicsBasicCalcs {
    
    init() {}
    
    // Addition
    func rwAdd (a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x + b.x, y: a.y + b.y);
    }
    
    func rwAdd (a: CGVector, b: CGVector) -> CGPoint {
        return CGPoint(x: a.dx + b.dx, y: a.dy + b.dy);
    }
    
    // Subtract
    func rwSub (a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x - b.y, y: a.y - b.y)
    }
    
    func rwSub (a: CGVector, b: CGVector) -> CGPoint {
        return CGPoint(x: a.dx - b.dy, y: a.dy - b.dy)
    }
    
    // Multiply
    func rwMult (a:CGPoint, b:Float) -> CGPoint {
        return CGPoint(x: a.x * CGFloat(b), y: a.y * CGFloat(b))
    }
    
    func rwMult (a:CGVector, b:Float) -> CGPoint {
        return CGPoint(x: a.dx * CGFloat(b), y: a.dy * CGFloat(b))
    }
    
    // Length
    func rwLength (a: CGPoint) -> Float {
        return sqrtf( Float(a.x * a.x) + Float(a.y * a.y))
    }
    
    func rwLength (a: CGVector) -> Float {
        return sqrtf( Float(a.dx * a.dx) + Float(a.dy * a.dy))
    }
    
    // Normalize
    // Makes a vector have a length of 1
    func rwNormalize(a: CGPoint) -> CGPoint {
        let length: CGFloat = CGFloat(rwLength(a: a))
        return CGPoint(x: a.x/length, y: a.y/length)
    }
    
    func rwNormalize(a: CGVector) -> CGPoint {
        let length: CGFloat = CGFloat(rwLength(a: a))
        return CGPoint(x: a.dx/length, y: a.dy/length)
    }
}
