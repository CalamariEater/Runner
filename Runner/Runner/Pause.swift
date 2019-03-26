//
//  Pause.swift
//  Runner
//
//  Created by Kevin John Bulosan on 3/17/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import SpriteKit
import GameplayKit

class Pause: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is Playing {
            print("PAAAAUUUUUSSSSSEEEEDDDD")
            openPaused()
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {}
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            closePaused()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
 
    // Helper Functions
    func openPaused() {
        scene.scoreLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 300)
        scene.highScoreLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 400)
        
        //let scale = SKAction.scale(to: 1.0, duration: 0.25)
        
        scene.gameMessage.text = "Paused"
        //scene.gameMessage2.text = "Quit"
        
        scene.gameMessage.setScale(1.0)
        //scene.gameMessage2.setScale(1.0)
        scene.scoreLabel.setScale(1.0)
        scene.highScoreLabel.setScale(1.0)
        
        print("Pause opened!")
    }
    
    func closePaused() {
        let scale = SKAction.scale(to: 0, duration: 0.4)
        scene.childNode(withName: "GameMessage")!.run(scale)
        //scene.childNode(withName: "GameMessage2")!.run(scale)
        
        print("Pause closed!")
    }
    
}
