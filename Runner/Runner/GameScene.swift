//
//  GameScene.swift
//  Runner
//
//  Created by Kevin John Bulosan on 3/10/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

/* TODO: dynamic block placing
 ~ Add more blocks dood
 ~ ANIMATION -- its not working hahahahahaha
 ~ Assests
 ~ Pausing (App delegate) 
 ~ events
 ~ wow this is ugly 10/24/18
*/

class GameScene: SKScene, SKPhysicsContactDelegate {
    var theScene: GameScene!
    
    // Bitmask
    let playerCategory   : UInt32 = 0x1 << 0
    let groundCategory : UInt32 = 0x1 << 1
    let dangerCategory  : UInt32 = 0x1 << 2
    let obstacleCategory : UInt32 = 0x1 << 3
    let borderCategory : UInt32 = 0x1 << 4
    let rightPlayerCategory: UInt32 = 0x1 << 5
    let topPlayerCategory: UInt32 = 0x1 << 6
    
    //var allTheDangers = [Danger]()
    
    var thePlayer: Player = Player(posX: 0.0, posY: -405)
    var theGround: SKSpriteNode = SKSpriteNode()
    var theGround2: SKSpriteNode = SKSpriteNode()
    
    let groundResetPos: CGPoint = CGPoint(x: 0,y: -584.5 )
    let groundResetPos2: CGPoint = CGPoint(x: 800,y: -584.5 )
    
    // Bools
    var isFingering = false
    var isGettingSickAir = false
    var playerAbove = false
    var didDoubleJump = false
    var isGamePaused = false
    
    var isTopped = false
    var isWalled = false

    // GameStates
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        Menu(scene: self),
        Playing(scene: self),
        Pause(scene: self),
        GameOver(scene: self)])
    
    // Menu Stuff
    let gameMessage = SKLabelNode(text: "Runner")
    let gameMessage2 = SKLabelNode(text: "Play")
    let gameMessage3 = SKLabelNode(text: "Quit")
    let gameMessage4 = SKLabelNode(text: "")
    
    let pauseButton = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 100, height: 100))
    
    // Speak Stuff
    let gameMessage5 = SKLabelNode(text: "")
    
    // Spawn Locations
    // var spawnPoints = [
    var spawn0: CGPoint = CGPoint()
    var spawn1: CGPoint = CGPoint()
    var spawn2: CGPoint = CGPoint()
    var spawn3: CGPoint = CGPoint()
    var spawn4: CGPoint = CGPoint()
    var spawn5: CGPoint = CGPoint()
    var spawn6: CGPoint = CGPoint()
    var spawn7: CGPoint = CGPoint()
    var spawn8: CGPoint = CGPoint()
    var spawn9: CGPoint = CGPoint()
    var spawn10: CGPoint = CGPoint()
    
    var previousSpawn = 0
    
    // var isPaused: Bool = false
    var gameTimer: Timer!
    var speakTimer: Timer!
    
    // Score Stuff
    var score = 0
    var highScore = 0
    let scoreLabel = SKLabelNode(text: "Score: 0")
    let highScoreLabel = SKLabelNode(text: "High Score: 0")
    let defaults = UserDefaults.standard
    
    
    
    override func didMove(to view: SKView) {
        
        //self.theScene = self
        
        self.backgroundColor = SKColor(colorLiteralRed: 80/255, green: 145/255, blue: 215/255, alpha: 1)
        
        // Set Border
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
 
 
        // Set Bitmasks
        theGround = childNode(withName: "ground") as! SKSpriteNode
        theGround2 = childNode(withName: "ground2") as! SKSpriteNode
        
        //thePlayer.baseBody.categoryBitMask = playerCategory
        //thePlayer.baseBody.collisionBitMask = groundCategory | obstacleCategory

        //thePlayer.topBody.categoryBitMask = topPlayerCategory
        //thePlayer.rightBody.categoryBitMask = rightPlayerCategory
        
        //thePlayer.physicsBody = SKPhysicsBody(bodies: [thePlayer.baseBody, thePlayer.topBody, thePlayer.rightBody])
        
        addChild(thePlayer)
        
        theGround.physicsBody?.categoryBitMask = groundCategory
        theGround2.physicsBody?.categoryBitMask = groundCategory
        thePlayer.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.categoryBitMask = borderCategory
        
        theGround.physicsBody?.collisionBitMask = playerCategory
        theGround2.physicsBody?.collisionBitMask = playerCategory
        thePlayer.physicsBody?.collisionBitMask = groundCategory | obstacleCategory
        
        physicsWorld.contactDelegate = self
        thePlayer.physicsBody!.contactTestBitMask = groundCategory | borderCategory | obstacleCategory | playerCategory | topPlayerCategory | rightPlayerCategory
 
        // Spawn Locations
        let farRightX = self.size.width/2
        spawn0 = CGPoint(x: farRightX, y: (-self.size.height/2) + theGround.size.height)
        spawn1 = CGPoint(x: farRightX, y: (-self.size.height/2) + theGround.size.height + thePlayer.size.height)
        spawn2 = CGPoint(x: farRightX, y: (-self.size.height/2) + theGround.size.height + (2 * thePlayer.size.height))
        spawn3 = CGPoint(x: farRightX, y: (-self.size.height/2) + theGround.size.height + (3 * thePlayer.size.height))
        spawn4 = CGPoint(x: farRightX, y: (-self.size.height/2) + theGround.size.height + (4 * thePlayer.size.height))
        spawn5 = CGPoint(x: farRightX, y: frame.midY)
        spawn6 = CGPoint(x: farRightX, y: theGround.size.height)
        spawn7 = CGPoint(x: farRightX, y: theGround.size.height + thePlayer.size.height)
        spawn8 = CGPoint(x: farRightX, y: theGround.size.height + (2 * thePlayer.size.height))
        spawn9 = CGPoint(x: farRightX, y: theGround.size.height + (3 * thePlayer.size.height))
        spawn10 = CGPoint(x: farRightX, y: theGround.size.height + (4 * thePlayer.size.height))
        
        // Menu Stuffs
        gameMessage.fontSize = 100
        gameMessage.fontColor = UIColor.black
        gameMessage.name = "GameMessage"
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        gameMessage.zPosition = 4
        gameMessage.setScale(0.0)
        addChild(gameMessage)
        
        gameMessage2.fontSize = 50
        gameMessage2.fontColor = UIColor.black
        gameMessage2.name = "GameMessage2"
        gameMessage2.position = CGPoint(x: frame.midX, y: frame.midY)
        gameMessage2.zPosition = 4
        gameMessage2.setScale(0.0)
        addChild(gameMessage2)
        
        gameMessage3.fontSize = 50
        gameMessage3.fontColor = UIColor.black
        gameMessage3.name = "GameMessage3"
        gameMessage3.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        gameMessage3.zPosition = 4
        gameMessage3.setScale(0.0)
        addChild(gameMessage3)
        
        gameMessage4.fontSize = 50
        gameMessage4.fontColor = UIColor.black
        gameMessage4.name = "GameMessage4"
        gameMessage4.position = CGPoint(x: frame.midX, y: frame.midY - 200)
        gameMessage4.zPosition = 4
        gameMessage4.setScale(0.0)
        addChild(gameMessage4)
        
        // Speak
        gameMessage5.fontSize = 50
        gameMessage5.fontColor = UIColor.black
        gameMessage5.name = "GameMessage5"
        gameMessage5.position = CGPoint(x: frame.midX, y: frame.midY + 200)
        gameMessage5.zPosition = 4
        gameMessage5.setScale(0.0)
        addChild(gameMessage5)
        
        // Score Stuff
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = UIColor.black
        scoreLabel.name = "ScoreLabel"
        scoreLabel.zPosition = 4
        scoreLabel.setScale(0.0)
        addChild(scoreLabel)
        
        highScoreLabel.fontSize = 50
        highScoreLabel.fontColor = UIColor.black
        highScoreLabel.name = "HighScoreLabel"
        highScoreLabel.zPosition = 4
        highScoreLabel.setScale(0.0)
        addChild(highScoreLabel)
        
        highScore = defaults.integer(forKey: "HighScore")
        highScoreLabel.text = "High Score: \(highScore)"
        print(highScore)
        
        // Pause Button
        pauseButton.position = CGPoint(x: frame.maxX - 100, y: frame.maxY - 100)
        pauseButton.texture = SKTexture(imageNamed: "pause")
        pauseButton.name = "PauseButton"
        pauseButton.zPosition = 4
        pauseButton.setScale(0.0)
        addChild(pauseButton)

        //homeButtonNotify()
        
        print("GameScene CREATED")
        thePlayer.walkStart()
        
        //let walkAnimation = SKAction.animate(withNormalTextures: thePlayer.walkFrames, timePerFrame: 0.1, resize: false, restore: true)
        
        //thePlayer.run(SKAction.repeatForever(walkAnimation), withKey: "walkingPlayer")
        
        
        let skView = self.view
        //skView?.showsFPS = true
        //skView?.showsNodeCount = true
        //skView?.showsPhysics = true
        
        
        theScene = self
        //let appDel = UIApplication.shared.delegate! as! AppDelegate
        
        
        gameState.enter(Menu.self)
    }
    
    func touchDown(toPoint pos : CGPoint) {}
    
    func touchMoved(toPoint pos : CGPoint) {}
    
    func touchUp(atPoint pos : CGPoint) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState.currentState {
        case is Menu:
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            
            if gameMessage2.frame.contains(touchLocation) {
                gameState.enter(Playing.self)
            }
            
        case is Playing:
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            //let theGround = childNode(withName: "ground") as! SKSpriteNode
            
            if pauseButton.frame.contains(touchLocation) {
                togglePaused()
            } else {
                isFingering = true
            }

        case is Pause:
            pausePress(touches: touches)
        case is GameOver:
            gameOverPress(touches: touches)
        default:
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFingering {
            // JUMP ((thePlayer.physicsBody?.velocity.dy)! == CGPoint(x: 0, y: 0).y)
            if  !isGettingSickAir {
                thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
            } else if !didDoubleJump || isWalled {
                doubleJump()
            }
            isFingering = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    
    override func update(_ currentTime: TimeInterval) {
        gameState.update(deltaTime: currentTime)

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Bodies involved in collision
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // player and ground collision
        if firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == groundCategory {
            //let test = thePlayer.sideCollided(contactPoint: contact)
            isGettingSickAir = false
            didDoubleJump = false
            isWalled = false
            isTopped = false
        }
        
        // player and obstacle collision
        if firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == obstacleCategory {
            let test = thePlayer.sideCollided(contactPoint: contact)
            if (test == thePlayer.right) || (test == thePlayer.right2) {
                isWalled = true
            } else if (test == thePlayer.up) || (test == thePlayer.up2) {
                isTopped = true
            }
            isWalled = false
            isTopped = false
            isGettingSickAir = false
            didDoubleJump = false // Causes "wall jump"
        }

        // player and danger collision
        if firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == dangerCategory {
            //print("You touched me~")
            //playSound(soundVar: ballBounceSound)
        }
        
        // player and border collision
        if firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == borderCategory {
            //print("TO THE WIIIINNNDOOOOOOWWWWSSSS~~~")
            //gameState.enter(GameOver.self)
            //playSound(soundVar: ballBounceSound)
        }
        
        // topPlayer and obstacle collision
        if firstBody.categoryBitMask == topPlayerCategory && secondBody.categoryBitMask == obstacleCategory {
            print("TOP")
        }
        
        // rightPlayer and obstacle collision
        if firstBody.categoryBitMask == rightPlayerCategory && secondBody.categoryBitMask == obstacleCategory {
            print("right")
        }

    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        // Bodies involved in collision
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // player and obstacle collision
        if firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == obstacleCategory {
            let test = thePlayer.sideCollided(contactPoint: contact)
            if (test == thePlayer.right) || (test == thePlayer.right2) {
                isWalled = false
            } else if (test == thePlayer.up) || (test == thePlayer.up2) {
                isTopped = false
            }
            isGettingSickAir = true
        }
        
        // player and ground collision
        if firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == groundCategory {
            isWalled = false
            isTopped = false
            isGettingSickAir = true
        }
        
        
        // TODO: Might wanna use
    }
    
    
    // HELPER FUNCTIONS
    
    func togglePaused() {
        
        isGamePaused = !isGamePaused
        
        let newSpeed:CGFloat = isGamePaused ? 0.0:1.0
        
        // spawningObstacles
        if let spawningAction = action(forKey: "obstacleSpawning") {
            spawningAction.speed = newSpeed
        }
        
        // talkMessage
        if let talkingMessage = action(forKey: "talkMessage") {
            talkingMessage.speed = newSpeed
        }
        
        // firstRun
        if let firsRun = action(forKey: "firstRun") {
            firsRun.speed = newSpeed
        }
        
        
        
        if isGamePaused {
            gameState.enter(Pause.self)
        } else {
            gameState.enter(Playing.self)
        }
        
        // Pause player
        thePlayer.physicsBody?.isDynamic = !(thePlayer.physicsBody?.isDynamic)!
    }
    
    func stopThings() {
        // Pause spawningObstacles
        if let spawningAction = action(forKey: "obstacleSpawning") {
            spawningAction.speed = 0.0
        }
        
        // Pause talkMessage
        if let talkingMessage = action(forKey: "talkMessage") {
            talkingMessage.speed = 0.0
        }
        
        // Pause firstRun
        if let firsRun = action(forKey: "firstRun") {
            firsRun.speed = 0.0
        }
        
        // Pause player
        thePlayer.physicsBody?.isDynamic = false
        

    }
    
    func startThings() {
        // Start spawningObstacles
        if let spawningObstacles = action(forKey: "obstacleSpawning") {
            spawningObstacles.speed = 1.0
        }
        
        // Start talkMessage
        if let talkingMessage = action(forKey: "talkMessage") {
            talkingMessage.speed = 1.0
        }
        
        // Start firstRun
        if let firsRun = action(forKey: "firstRun") {
            firsRun.speed = 0.0
        }
        
        // Start player
        thePlayer.physicsBody?.isDynamic = true
    }
    
    func dangerRemove(node: SKNode) {
        node.removeAllActions()
        node.removeFromParent()
    }
    
    func addDangerAtGround() {
        let danger = Danger(name: "Spaceship.png", physics: false)
        
        danger.position = CGPoint(x: spawn0.x, y: spawn0.y + danger.size.height/2 )
        
        danger.physicsBody?.categoryBitMask = dangerCategory
        danger.physicsBody?.collisionBitMask = groundCategory | playerCategory
        danger.physicsBody?.affectedByGravity = false
        
        addChild(danger)
        //allTheDangers.append(danger)
        //print("danger DANGER")
    }
    
    func addDangerAtLocation(location: CGPoint) {
        let danger = Danger(name: "Spaceship.png",physics: false)
        danger.position = CGPoint(x: location.x, y: location.y + danger.size.height/2 )
        
        danger.physicsBody?.categoryBitMask = dangerCategory
        danger.physicsBody?.collisionBitMask = groundCategory | playerCategory
        danger.physicsBody?.affectedByGravity = false
        
        addChild(danger)
        //allTheDangers.append(danger)
        //print("danger DANGER")
    }
    
    func addPhysicsDanger(touchLocation: CGPoint) {
        let danger = Danger(point: touchLocation, name: "Spaceship.png", physics: true)
        
        danger.physicsBody?.categoryBitMask = dangerCategory
        danger.physicsBody?.collisionBitMask = groundCategory | playerCategory
        danger.physicsBody?.affectedByGravity = false
        
        addChild(danger)
        //allTheDangers.append(danger)
        //print("danger DANGER")
    }
    
    /*
    func pickRandomSpawnBACKUP() -> CGPoint {
        //let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        
        if !playerAbove {
            switch previousSpawn {
            case 0:
                let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
                switch rando {
                case 0:
                    previousSpawn = 1
                    return spawn1
                case 1:
                    previousSpawn = 2
                    return spawn2
                case 2:
                    previousSpawn = 2
                    return spawn2
                default:
                    break
                }
            case 1:
                let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
                switch rando {
                case 0: // SAME CASE
                    previousSpawn = 1
                    return spawn0
                case 1:
                    previousSpawn = 2
                    return spawn1
                case 2:
                    previousSpawn = 3
                    return spawn3
                case 3:
                    previousSpawn = 3
                    return spawn3
                default:
                    break
                }
            case 2:
                let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 5)
                switch rando {
                case 0: // SAME CASE
                    previousSpawn = 2
                    return spawn2
                case 1:
                    previousSpawn = 3
                    return spawn3
                case 2:
                    previousSpawn = 3
                    return spawn3
                case 3:
                    previousSpawn = 4
                    return spawn4
                case 5:
                    previousSpawn = 4
                    return spawn4
                default:
                    break
                }
            case 3:
                let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 5)
                switch rando {
                case 0: // SAME CASE
                    previousSpawn = 3
                    return spawn3
                case 1:
                    previousSpawn = 4
                    return spawn4
                case 2:
                    previousSpawn = 4
                    return spawn4
                case 3:
                    previousSpawn = 5
                    return spawn5
                case 4:
                    previousSpawn = 5
                    return spawn5
                default:
                    break
                }
            case 4:
                let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 5)
                switch rando {
                case 0:
                    previousSpawn = 3
                    return spawn3
                case 1:// SAME CASE
                    previousSpawn = 4
                    return spawn4
                case 2:
                    previousSpawn = 5
                    return spawn5
                case 3:
                    previousSpawn = 5
                    return spawn5
                case 4:
                    previousSpawn = 6
                    return spawn6
                default:
                    break
                }
            default:
                return spawn0
            }
        } else {
            //let random = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
            switch previousSpawn {
            case 0:
                let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 5)
                switch rando {
                case 0:
                    previousSpawn = 3
                    return spawn3
                case 1:
                    previousSpawn = 4
                    return spawn4
                case 2: // SAME CASE
                    previousSpawn = 5
                    return spawn5
                case 3:
                    previousSpawn = 6
                    return spawn6
                case 4:
                    previousSpawn = 7
                    return spawn7
                default:
                    break
                }
            case 1:
                let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
                switch rando {
                case 0:
                    previousSpawn = 5
                    return spawn5
                case 1: // SAME CASE
                    previousSpawn = 6
                    return spawn6
                case 2:
                    previousSpawn = 7
                    return spawn7
                default:
                    break
                }
            case 2:
                let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
                switch rando {
                case 0:
                    previousSpawn = 5
                    return spawn5
                case 1:
                    previousSpawn = 6
                    return spawn6
                case 2: // SAME CASE
                    previousSpawn = 7
                    return spawn7
                case 3:
                    previousSpawn = 8
                    return spawn8
                default:
                    break
                }
            case 3:
                let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 6)
                switch rando {
                case 0:
                    previousSpawn = 5
                    return spawn5
                case 1:
                    previousSpawn = 6
                    return spawn6
                case 2:
                    previousSpawn = 7
                    return spawn7
                case 3:  // SAME CASE
                    previousSpawn = 8
                    return spawn8
                case 4:
                    previousSpawn = 8
                    return spawn9
                case 5:
                    previousSpawn = 8
                    return spawn10
                default:
                    break
                }
                default:
                    return spawn0
            }
        }
        return spawn0
    }*/
    
    /*
    func pickRandomObstacle() {
        let rando = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        switch rando {
        case 0:
            let platform = PlatformSmall(point: pickRandomSpawn(), categoryBitMask: obstacleCategory, collisionBitMask: playerCategory, contactTestBitMask: borderCategory)
            addChild(platform)
            //addPlatformAtLocation(location: pickRandomSpawn())
        case 1:
            let platform = PlatformBlock(point: pickRandomSpawn(), categoryBitMask: obstacleCategory, collisionBitMask: playerCategory, contactTestBitMask: borderCategory)
            addChild(platform)
            //addPlatformBlockAtLocation(location: pickRandomSpawn())
        case 2:
            let platform = PlatformLong(point: pickRandomSpawn(), categoryBitMask: obstacleCategory, collisionBitMask: playerCategory, contactTestBitMask: borderCategory)
            addChild(platform)
            //addPlatformLongAtLocation(location: pickRandomSpawn())
        case 3:
            print("stairs added!")
            //platformSmallStairs(location: pickRandomSpawn(), fleights: 5, catMask: obstacleCategory, collMask: playerCategory, contMask: borderCategory, scene: theScene)
        default:
            break
        }
    }*/
    
    func doubleJump() {
        thePlayer.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
        
        didDoubleJump = true
    }
    
    func pausePress(touches: Set<UITouch>) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if pauseButton.frame.contains(touchLocation) {
            togglePaused()
        }
    }
    
    func gameOverPress(touches: Set<UITouch>) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if gameMessage2.frame.contains(touchLocation) {
            gameState.enter(Playing.self)
        }
        
        if gameMessage3.frame.contains(touchLocation) {
            gameState.enter(Menu.self)
        }
    }
    
    func talkMessage (message: String, speed: Double, width: Int, delay: Double, theWait: Double) {
        var i = 1
        //var k: CGFloat = 1
        let messageYo = message
        let limit = width
        var inDelay = false
        
        var isSpace = false
        var checkSpace = false
        
        var start = message.index(message.startIndex, offsetBy: 0)
        var end = message.index(message.endIndex, offsetBy: i - message.characters.count)
        var range = start..<end
        
        // Clear label
        gameMessage5.text = ""
        
        // Bring message in
        let scale = SKAction.scale(to: 1.0, duration: 0.25)
        childNode(withName: "GameMessage5")!.run(scale)
        
        if action(forKey: "talkMessage") == nil {
            let wait = SKAction.wait(forDuration: speed)
            
            let talkMessage = SKAction.run { [unowned self] in
                if !inDelay {
                    if (i % limit == 0) || checkSpace {
                        
                        if !isSpace {
                            checkSpace = true
                        } else {
                            // Allow time for user to read
                            inDelay = true
                            
                            let wait = SKAction.wait(forDuration: delay)
                            
                            let startOfMessage = SKAction.run {
                                // Set new start of message
                                start = message.index(message.startIndex, offsetBy: i - 1)
                                inDelay = false
                                checkSpace = false
                            }
                            
                            let sequence = SKAction.sequence([wait, startOfMessage])
                            
                            self.run(sequence)
            
                        }
                    }
                    
                    end = message.index(message.endIndex, offsetBy: i - message.characters.count - 1) //increment beyond error
                    range = start..<end
                    let input = message.substring(with: range)
                    self.gameMessage5.text = input
                    
                    // Check if current Character is a space
                    if !(i >= message.characters.count) {
                        let spaceCheckStart = message.index(message.startIndex, offsetBy: i)
                        let spaceCheckEnd = message.index(message.startIndex, offsetBy: i + 1)
                        let spaceCheckRange = spaceCheckStart..<spaceCheckEnd
                        let spaceCheck = message.substring(with: spaceCheckRange)
                        
                        if spaceCheck == " " {
                            isSpace = true
                        } else {
                            isSpace = false
                        }
                    }
                    i += 1
                }

                if messageYo.characters.count < i {
                    
                    self.removeAction(forKey: "talkMessage")
                    
                    let wait = SKAction.wait(forDuration: theWait)
                    
                    let stopTalkMessage = SKAction.run {
                        let scale = SKAction.scale(to: 0, duration: 0.4)
                        self.childNode(withName: "GameMessage5")!.run(scale)
                    }
                    
                    let sequence = SKAction.sequence([wait, stopTalkMessage])
                    
                    self.run(sequence)
                    
                }

            }
            
            let sequence = SKAction.sequence([talkMessage, wait])
            
            run(SKAction.repeatForever(sequence), withKey: "talkMessage")
        }
    }
    
    func talkMessage (message: String) {
        var i = 1
        //var k: CGFloat = 1
        let messageYo = message
        let limit = 10
        var inDelay = false
        
        var isSpace = false
        var checkSpace = false
        
        var start = message.index(message.startIndex, offsetBy: 0)
        var end = message.index(message.endIndex, offsetBy: i - message.characters.count)
        var range = start..<end
        
        // Clear label
        gameMessage5.text = ""
        
        // Bring message in
        let scale = SKAction.scale(to: 1.0, duration: 0.25)
        childNode(withName: "GameMessage5")!.run(scale)
        
        if action(forKey: "talkMessage") == nil {
            let wait = SKAction.wait(forDuration: 0.1)
            
            let talkMessage = SKAction.run { [unowned self] in
                if !inDelay {
                    if (i % limit == 0) || checkSpace {
                        
                        if !isSpace {
                            checkSpace = true
                        } else {
                            // Allow time for user to read
                            inDelay = true
                            
                            let wait = SKAction.wait(forDuration: 1)
                            
                            let startOfMessage = SKAction.run {
                                // Set new start of message
                                start = message.index(message.startIndex, offsetBy: i - 1)
                                inDelay = false
                                checkSpace = false
                            }
                            
                            let sequence = SKAction.sequence([wait, startOfMessage])
                            
                            self.run(sequence)
                            
                        }
                    }
                    
                    end = message.index(message.endIndex, offsetBy: i - message.characters.count - 1) //increment beyond error
                    range = start..<end
                    let input = message.substring(with: range)
                    self.gameMessage5.text = input
                    
                    // Check if current Character is a space
                    if !(i >= message.characters.count) {
                        let spaceCheckStart = message.index(message.startIndex, offsetBy: i)
                        let spaceCheckEnd = message.index(message.startIndex, offsetBy: i + 1)
                        let spaceCheckRange = spaceCheckStart..<spaceCheckEnd
                        let spaceCheck = message.substring(with: spaceCheckRange)
                        
                        if spaceCheck == " " {
                            isSpace = true
                        } else {
                            isSpace = false
                        }
                    }
                    i += 1
                }
                
                if messageYo.characters.count < i {
                    
                    self.removeAction(forKey: "talkMessage")
                    
                    let wait = SKAction.wait(forDuration: 1)
                    
                    let stopTalkMessage = SKAction.run {
                        let scale = SKAction.scale(to: 0, duration: 0.4)
                        self.childNode(withName: "GameMessage5")!.run(scale)
                    }
                    
                    let sequence = SKAction.sequence([wait, stopTalkMessage])
                    
                    self.run(sequence)
                    
                }
                
            }
            
            let sequence = SKAction.sequence([talkMessage, wait])
            
            run(SKAction.repeatForever(sequence), withKey: "talkMessage")
        }
    }
    
    /*
    protocol SceneDelegate: class {
        func getScene() -> GameScene!
    }*/
}
