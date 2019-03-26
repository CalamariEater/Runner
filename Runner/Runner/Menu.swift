//
//  Menu.swift
//  Runner
//
//  Created by Kevin John Bulosan on 3/17/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import SpriteKit
import GameplayKit

class Menu: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is GameOver {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {_ in
                self.openMenu()
            }
        }
        else {
            openMenu()
            //scene.talkMessage(message: "This is a test!", speed: 0.05)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {}
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            closeMenu()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
    
    // Helper Functions
    
    func openMenu() {
        // Reposition Score
        scene.highScoreLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 300)
        
        let scale = SKAction.scale(to: 1.0, duration: 0.25)
        
        scene.gameMessage.text = "Runner"
        scene.gameMessage2.text = "Play"
        //scene.gameMessage3.text = "Quit"
        
        scene.childNode(withName: "GameMessage")!.run(scale)
        scene.childNode(withName: "GameMessage2")!.run(scale)
        //scene.childNode(withName: "GameMessage3")!.run(scale)
        scene.childNode(withName: "HighScoreLabel")!.run(scale)
    }
    
    func closeMenu() {
        let scale = SKAction.scale(to: 0, duration: 0.4)
        scene.childNode(withName: "GameMessage")!.run(scale)
        scene.childNode(withName: "GameMessage2")!.run(scale)
        //scene.childNode(withName: "GameMessage3")!.run(scale)
        
        //let testMessage = "The quick brown fox jumped over the lazy doggo!"
        //scene.talkMessage(message: testMessage, speed: 0.1, width: 10, delay: 1)
        //scene.childNode(withName: "GameMessage4")!.run(scale)
    }
    
}
