//
//  GameOver.swift
//  Runner
//
//  Created by Kevin John Bulosan on 3/17/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is Playing {
            openGameOver()
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {}
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing || nextState is Menu {
            closeGameOver()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is Playing.Type || stateClass is Menu.Type {
            return true
        }
        return false
    }
    
    // Helper Functions
    
    func openGameOver() {
        scene.scoreLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 300)
        scene.highScoreLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 400)
        
        let scale = SKAction.scale(to: 1.0, duration: 0.25)
        
        scene.gameMessage.text = "You Lose!"
        scene.gameMessage2.text = "Again?"
        scene.gameMessage3.text = "Menu"
        //scene.gameMessage4.text = "Quit"
        
        scene.childNode(withName: "GameMessage")!.run(scale)
        scene.childNode(withName: "GameMessage2")!.run(scale)
        scene.childNode(withName: "GameMessage3")!.run(scale)
        //scene.childNode(withName: "GameMessage4")!.run(scale)
        scene.childNode(withName: "ScoreLabel")!.run(scale)
        scene.childNode(withName: "HighScoreLabel")!.run(scale)
    }
    
    func closeGameOver() {
        let scale = SKAction.scale(to: 0, duration: 0.4)
        scene.childNode(withName: "GameMessage")!.run(scale)
        scene.childNode(withName: "GameMessage2")!.run(scale)
        scene.childNode(withName: "GameMessage3")!.run(scale)
        //scene.childNode(withName: "GameMessage4")!.run(scale)
        scene.scoreLabel.setScale(0.0)
        scene.highScoreLabel.setScale(0.0)
        reset()
    }
    
    func reset() {
        
        // Reset all the THINGS
        scene.theGround.position = CGPoint(x: 0, y: -585)
        scene.thePlayer.position = CGPoint(x: 0, y: -405)
        scene.previousSpawn = 0
        scene.score = 0
        scene.scoreLabel.text = "Score: \(scene.score)"
        
        // Remove all dangers from the scene
        scene.enumerateChildNodes(withName: "obstacle") {
            node, stop in
            if let dangerFound = node as? Danger {
                dangerFound.removeFromParent()
            }
        }
    }
    
}
