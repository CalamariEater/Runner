//
//  Playing.swift
//  Runner
//
//  Created by Kevin John Bulosan on 3/17/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
    unowned let scene: GameScene
    
    //private let defaultMovementPhys = CGVector(dx: -1, dy: 0)
    private var movement: CGFloat =  5 //8
    private let defaultMovement: CGFloat = 5
    private var acceleration: CGFloat = 0.001
    private let defaultAcceleration: CGFloat = 0.001
    
    var spawnTime = 1.5
    var defaultSpawnTime = 2.0
    
    private var offScreen = false
    
    //private var currentSpeed: CGFloat = 0
    private let maxMovement: CGFloat = 30
    

    // Spawning stuff
    struct spawn {
        var point = CGPoint()
        var height = 0
    }
    
    private var previousDanger = ""
    private var playerIsAbove = false
    private var playerBetween = false
    private var currSpawn = spawn()
    
    var spawn0 = spawn()
    var spawn1 = spawn()
    var spawn2 = spawn()
    var spawn3 = spawn()
    var spawn4 = spawn()
    var spawn5 = spawn()
    var spawn6 = spawn()
    var spawn7 = spawn()
    var spawn8 = spawn()
    var spawn9 = spawn()
    var spawn10 = spawn()
    
    var speedUpSpawn = 30
    var topSpeedSpawn: CGFloat = 2.0
    
    // Difficulty
    private var time = 0
    
    private let lvl1 = 20
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is Menu || previousState is GameOver {
            if !scene.defaults.bool(forKey: "notFirstRun") {
                firstRun()
            } else {
                openPlay()
            }
        } else if previousState is Pause {
            repositionThings()
        }
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is GameOver {
            closePlay()
        } else if nextState is Pause {
            // do nothing
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        dangerMovement()
        centerPlayer()
        playerPos()
        playerOutOfBounds()
        groundMove()
        animatePlayer()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is Pause.Type || stateClass is GameOver.Type {
            return true
        }
        return false
    }
    
    //********************************************************************
    // Helper Functions
    //******************************
    
    func initSpawns() {
        
        // Spawn Locations
        let farRightX = self.scene.size.width/2
        spawn0.point = CGPoint(x: farRightX, y: (-self.scene.size.height/2) + scene.theGround.size.height)
        spawn0.height = 0
        
        spawn1.point = CGPoint(x: farRightX, y: (-self.scene.size.height/2) + scene.theGround.size.height + scene.thePlayer.size.height)
        spawn1.height = 1
        
        spawn2.point = CGPoint(x: farRightX, y: (-self.scene.size.height/2) + scene.theGround.size.height + (2 * scene.thePlayer.size.height))
        spawn2.height = 2
        
        spawn3.point = CGPoint(x: farRightX, y: (-self.scene.size.height/2) + scene.theGround.size.height + (3 * scene.thePlayer.size.height))
        spawn3.height = 3
        
        spawn4.point = CGPoint(x: farRightX, y: (-self.scene.size.height/2) + scene.theGround.size.height + (4 * scene.thePlayer.size.height))
        spawn4.height = 4
        
        spawn5.point = CGPoint(x: farRightX, y: scene.frame.midY)
        spawn5.height = 5
        
        spawn6.point = CGPoint(x: farRightX, y: scene.theGround.size.height)
        spawn6.height = 6
        
        spawn7.point = CGPoint(x: farRightX, y: scene.theGround.size.height + scene.thePlayer.size.height)
        spawn7.height = 7
        
        spawn8.point = CGPoint(x: farRightX, y: scene.theGround.size.height + (2 * scene.thePlayer.size.height))
        spawn8.height = 8
        
        spawn9.point = CGPoint(x: farRightX, y: scene.theGround.size.height + (3 * scene.thePlayer.size.height))
        spawn9.height = 9
        
        spawn10.point = CGPoint(x: farRightX, y: scene.theGround.size.height + (4 * scene.thePlayer.size.height))
        spawn10.height = 10
    }
    
    func openPlay() {
        initSpawns()
        repositionThings()
        
        scene.theGround.position = scene.groundResetPos
        scene.theGround2.position = scene.groundResetPos2
        
        acceleration = defaultAcceleration
        spawnTime = defaultSpawnTime
        
        startSpawningObstacles()
    
        print("Pause closed!")
    }
    
    func closePlay() {
        scene.scoreLabel.setScale(0.0)
        scene.highScoreLabel.setScale(0.0)
        scene.pauseButton.setScale(0.0)
        
        //scene.theGround.position = scene.groundResetPos
        //scene.theGround2.position = scene.groundResetPos2
        
        scene.removeAction(forKey: "obstacleSpawning")
        print("timer stopped")
    }
    
    func repositionThings() {
        // Reposition score
        scene.highScoreLabel.position = CGPoint(x: scene.frame.minX + 200, y: scene.frame.maxY - 100)
        scene.scoreLabel.position = CGPoint(x: scene.frame.minX + 150, y: scene.frame.maxY - 200)
        //scene.highScoreLabel.position = CGPoint(x: scene.frame.maxX - 200, y: scene.frame.maxY - 100)
        
        scene.scoreLabel.setScale(1.0)
        scene.highScoreLabel.setScale(1.0)
        scene.pauseButton.setScale(1.0)
        
    }
    
    func updateScore() {
        scene.score += 1
        scene.scoreLabel.text = "Score: \(scene.score)"
        if scene.score > scene.highScore {
            scene.highScore = scene.score
            scene.highScoreLabel.text = "High Score: \(scene.highScore)"
            scene.defaults.set(scene.highScore, forKey: "HighScore")
        }
    }
    
    func randomDirection() -> CGFloat {
        let speedFactor: CGFloat = 3.0
        if randomFloat(from: 0.0, to: 100.0) >= 50 {
            return -speedFactor
        } else {
            return speedFactor
        }
        
    }
    
    func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
        let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return (rand) * (to - from) + from
    }
    
    func pickRandomObstacle() {
        let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        switch rando {
        case 0:
            let ob = PlatformSmall(point: currSpawn.point, categoryBitMask: scene.obstacleCategory, collisionBitMask: scene.playerCategory, contactTestBitMask: scene.borderCategory)
            let theOb = ob.resolve(spwnHeight: currSpawn.height, spwnPoint: currSpawn.point, previousDanger: previousDanger, catBitMask: scene.obstacleCategory, colBitMask: scene.playerCategory, testBitMask: scene.borderCategory)
            scene.addChild(theOb)
            previousDanger = theOb.theName
            
        case 1:
            let ob = PlatformBlock(point: currSpawn.point, categoryBitMask: scene.obstacleCategory, collisionBitMask: scene.playerCategory, contactTestBitMask: scene.borderCategory)
            
            let theOb = ob.resolve(spwnHeight: currSpawn.height, spwnPoint: currSpawn.point, previousDanger: previousDanger, catBitMask: scene.obstacleCategory, colBitMask: scene.playerCategory, testBitMask: scene.borderCategory)
            scene.addChild(theOb)
            previousDanger = theOb.theName
        case 2:
            let ob = PlatformLong(point: currSpawn.point, categoryBitMask: scene.obstacleCategory, collisionBitMask: scene.playerCategory, contactTestBitMask: scene.borderCategory)
            let theOb = ob.resolve(spwnHeight: currSpawn.height, spwnPoint: currSpawn.point, previousDanger: previousDanger, catBitMask: scene.obstacleCategory, colBitMask: scene.playerCategory, testBitMask: scene.borderCategory)
            scene.addChild(theOb)
            previousDanger = theOb.theName
        case 3:
            let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
            let ob = platformSmallStairs(point: currSpawn.point, fleights: rando + 2, catMask: scene.obstacleCategory, collMask: scene.playerCategory, contMask: scene.borderCategory, scene: scene.theScene)
            previousDanger = ob.obName
        default:
            break
        }
    }
    
    func pickRandomSpawn() {
        if playerBetween {
            // Spawn between
            print("Between")
            let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
            switch rando {
            case 0:
                currSpawn = spawn3
            case 1:
                currSpawn = spawn4
            case 2:
                currSpawn = spawn5
            case 3:
                currSpawn = spawn6
            default:
                break
            }
        } else if playerIsAbove {
            print("Above")
            let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 5)
            switch rando {
            case 0:
                currSpawn = spawn5
            case 1:
                currSpawn = spawn6
            case 2:
                currSpawn = spawn7
            case 3:
                currSpawn = spawn8
            case 4:
                currSpawn = spawn9
            default:
                break
            }
        } else {
            print("Below")
            let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
            switch rando {
            case 0:
                currSpawn = spawn0
            case 1:
                currSpawn = spawn1
            case 2:
                currSpawn = spawn2
            case 4:
                currSpawn = spawn3
            default:
                break
            }
        }
    }
    
    func groundMove() {
        
        // Move ground
        var currentSpeed = self.movement + self.acceleration
        if currentSpeed > self.maxMovement {
            currentSpeed = self.maxMovement
            //print(currentSpeed)
        }
        scene.theGround.position = CGPoint(x: scene.theGround.position.x - currentSpeed, y: scene.theGround.position.y)
        scene.theGround2.position = CGPoint(x: scene.theGround2.position.x - currentSpeed, y: scene.theGround2.position.y)
        
        let outOfBounds = ((-self.scene.size.width/2) + (-scene.theGround.size.width/2))
        if outOfBounds > (scene.theGround.position.x) {
            scene.theGround.position = scene.groundResetPos2
        } else if outOfBounds > (scene.theGround2.position.x) {
            scene.theGround2.position = scene.groundResetPos2
        }
    }
    
    //---------------------
    // Checks
    
    func animatePlayer(){
        if scene.isWalled {
            scene.thePlayer.zRotation = CGFloat(M_PI_2)
        } else {
            scene.thePlayer.zRotation = 0.0
        }
    }
    
    func playerPos() {
        if scene.thePlayer.position.y > (scene.frame.midY + scene.theGround.frame.height) {
            playerIsAbove = true
            playerBetween = false
            offScreen = false
        } else if scene.thePlayer.position.y > (scene.frame.midY) {
            playerBetween = true
            playerIsAbove = false
            offScreen = false
        } else {
            playerIsAbove = false
            playerBetween = false
            offScreen = false
        }
        
        if scene.thePlayer.position.y > (scene.frame.maxY) {
            offScreen = true
        }
    }
    
    func dangerMovement() {
        scene.enumerateChildNodes(withName: "obstacle") {
            node, stop in
            
            if let dangerFound = node as? Danger {
                var currentSpeed = self.movement + self.acceleration
                if currentSpeed > self.maxMovement {
                    currentSpeed = self.maxMovement
                    //print(currentSpeed)
                }
                dangerFound.position = CGPoint(x: dangerFound.position.x - currentSpeed, y: dangerFound.position.y)
                self.didScore(danger: dangerFound)
                //danger.position = CGPoint(x: danger.position.x - (defaultMovement + acceleration), y: danger.position.y)
                self.acceleration += 0.001
                self.removeDangerOutOfBounds(dangerFound: dangerFound)
            }
 
        }
    }
    
    func didScore(danger: Danger) {
        if (danger.position.x - danger.frame.width/2) < (scene.thePlayer.position.x - scene.thePlayer.frame.width/2) {
            if danger.scored == false {
                if playerIsAbove == true {
                    updateScore()
                    updateScore()
                } else if offScreen == true {
                    updateScore()
                    updateScore()
                    updateScore()
                    updateScore()
                    updateScore()
                } else {
                    updateScore()
                }
                danger.scored = true
            }
        }
    }
    
    func centerPlayer() {
        if (scene.thePlayer.position.x < 2) {
            scene.thePlayer.position.x += 1
        }
    }
    
    func playerOutOfBounds() {
        let outOfBounds = ((-self.scene.size.width/2) + (-scene.thePlayer.size.width/2))
        if outOfBounds > (scene.thePlayer.position.x) {
            scene.gameState.enter(GameOver.self)
            print("Goodbye my friend...")
        }
    }
    
    func removeDangerOutOfBounds(dangerFound: Danger) {
        let outOfBounds = ((-self.scene.size.width/2) + (-dangerFound.size.width/2))
        if outOfBounds > (dangerFound.position.x) {
            dangerFound.removeFromParent()
            //updateScore()
            //print("ITS BEEN REMOVED SIR!")
        }
    }
    
    func eventCheck() {
        if time == 10 {
            
        }
    }
    
    func speedUpSpawnCheck() {
        
        if time % speedUpSpawn == 0 {
            if let spawningAction = scene.action(forKey: "obstacleSpawning") {
                var currSpawnSpeed = spawningAction.speed
                if currSpawnSpeed <= topSpeedSpawn {
                    print("Spawning Obs Increased!")
                    currSpawnSpeed += 1 //0.05 TODO: DETERMINE IF ITS WORKING
                    spawningAction.speed = currSpawnSpeed
                }
            }
        }
    }
    
    //----------------------------
    // Events
    
    func startSpawningObstacles() {
        
        if scene.action(forKey: "obstacleSpawning") == nil {
            let wait = SKAction.wait(forDuration: spawnTime)
            
            let spawnObstacles = SKAction.run { [unowned self] in
                //print("obstacle spawned!")
                self.pickRandomSpawn()
                self.pickRandomObstacle()
                self.time += 1
                self.speedUpSpawnCheck()
            }
            
            let sequence = SKAction.sequence([spawnObstacles, wait])
            
            scene.run(SKAction.repeatForever(sequence), withKey: "obstacleSpawning")
            
        }
    }
    
    func removeGround() {
        //let theGround = scene.childNode(withName: "ground") as! SKSpriteNode
        
    }
    
    func firstRun() {
        repositionThings()
        //scene.pauseButton.setScale(0.0)
        scene.defaults.set(true, forKey: "notFirstRun")
        initSpawns()
        
        if scene.action(forKey: "firstRun") == nil {
            
            // Do first run
            scene.gameMessage5.fontSize = 100
            scene.talkMessage(message: "Tap to jump!", speed: 0.1, width: 15, delay: 1.0, theWait: 5.0)
        
            let wait7 = SKAction.wait(forDuration: 7)
            let wait2 = SKAction.wait(forDuration: 2)
            let wait3 = SKAction.wait(forDuration: 3)
            let wait4 = SKAction.wait(forDuration: 4)
            let wait5 = SKAction.wait(forDuration: 5)
            let wait10 = SKAction.wait(forDuration: 10)
        
            // Oh no!
            let ohNo = SKAction.run {
                self.scene.talkMessage(message: "Oh no!", speed: 0.1, width: 20, delay: 1.0, theWait: 1.0)
            }
        
            // There's something on the road!
            let theresSomething = SKAction.run {
                self.scene.gameMessage5.fontSize = 50
                self.scene.talkMessage(message: "There's something on the road!", speed: 0.1, width: 30, delay: 0.3, theWait: 1.0)
            }
        
            // Look out!
            let lookOut = SKAction.run {
                self.scene.gameMessage5.fontSize = 100
                self.scene.talkMessage(message: "Look out!", speed: 0.1, width: 20, delay: 1.0, theWait: 1.0)
            }
        
            // Spawn slow af block
            let slowAFBlock = SKAction.run {
                self.movement = 0.5
                let slowAFBlock = PlatformSmall(point: self.scene.spawn0, categoryBitMask: self.scene.obstacleCategory, collisionBitMask: self.scene.playerCategory, contactTestBitMask: self.scene.borderCategory)
                self.scene.addChild(slowAFBlock)
            }

            // Phew!
            let phew = SKAction.run {
                self.scene.gameMessage5.fontSize = 100
                self.scene.talkMessage(message: "Phew!", speed: 0.1, width: 20, delay: 1.0, theWait: 0.5)
            }
        
            // That was a close one!
            let closeOne = SKAction.run {
                self.scene.gameMessage5.fontSize = 50
                self.scene.talkMessage(message: "That was a close one!", speed: 0.08, width: 20, delay: 1.0, theWait: 0.7)
            }
        
            // Good job!
            let goodJob = SKAction.run {
                self.scene.gameMessage5.fontSize = 100
                self.scene.talkMessage(message: "Good Job!", speed: 0.1, width: 20, delay: 1.0, theWait: 0.7)
            }
        
            // Oh man
            let ohMan = SKAction.run {
                self.scene.talkMessage(message: "oh man", speed: 0.1, width: 20, delay: 1.0, theWait: 0.7)
            }
        
            // There's more coming!
            let moreComing = SKAction.run {
                self.scene.gameMessage5.fontSize = 50
                self.scene.talkMessage(message: "There's more coming!", speed: 0.1, width: 20, delay: 1.0, theWait: 1.0)
            }
        
            // First run done!
            let firstRunDone = SKAction.run {
                self.movement = self.defaultMovement
                self.startSpawningObstacles()
                //self.scene.pauseButton.setScale(1.0)
            }
        
            let sequence = SKAction.sequence([wait7, ohNo, wait2, theresSomething, wait5, lookOut, wait2, slowAFBlock, wait10, phew, wait2, closeOne, wait3, goodJob, wait4, ohMan, wait2, moreComing, wait3, firstRunDone])
            scene.run(sequence, withKey: "firstRun")
            
        }
        
    }
}
