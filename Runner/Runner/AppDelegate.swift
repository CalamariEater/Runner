//
//  AppDelegate.swift
//  Runner
//
//  Created by Kevin John Bulosan on 3/10/17.
//  Copyright © 2017 Kevin John Bulosan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //var myScene: GameScene!
    
    var window: UIWindow?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        //let theScene = GameScene()
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.myScene = theScene
        //let myScene =
        /*
        
        
        if myScene.gameState.currentState == nil {
            print("ITS FUCKING NIL")
        }
        
        if myScene.gameState.currentState is Playing {
            print("resigning activity!")
            myScene.stopThings()
        }*/
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        /*
        let theScene = GameScene()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myScene = theScene
        
        if myScene.gameState.currentState is Playing {
            print("becoming active!")
            myScene.startThings()
            myScene.gameState.enter(Pause.self)
        }*/
        
        /*
        let theScene = GameScene()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myScene = theScene
        
        myScene.togglePaused()
        myScene.gameState.enter(Pause.self)
        print("is becoming active")*/
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Helper Functions
    /*
    func pause() {
        let theScene = GameScene()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myScene = theScene
        
        myScene.gameTimer.invalidate()
        myScene.gameTimer = nil
    }*/
    

}

