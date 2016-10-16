//
//  AppDelegate.swift
//  Example
//
//  Created by ParkKisuk on 2016. 10. 16..
//  Copyright © 2016년 kisukpark. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // 1. Initailize a containerController.
    //    It will control menu animation.
    let containerController = ContainerController()
    
    // 2. Initialize one menu view controller and one main view controller.
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let main1 = storyboard.instantiateViewController(withIdentifier: "Main1ViewController") as! Main1ViewController
    let menu = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
    
    // 3. Set menu and main view controllers as child view controllers of container controller.
    containerController.setSideMenuChildViewControllers(mainViewController: main1,
                                                        menuViewController: menu)
    
    // 4. Set options you need.
    // Check for README.md for more details.
//    containerController.sideMenuMenuWidth
//    containerController.sideMenuMainHeightReduction
//    containerController.sideMenuBackground
//    containerController.sideMenuAnimationCurve
//    containerController.sideMenuAnimationDelay
//    containerController.sideMenuAnimationDuration
//    containerController.sideMenuPanGestureEnable
//    containerController.sideMenuTouchGestureEnable
    
    // NOTE: You can change main view controller to another one later.
    // Check for MenuTableViewController.swift
    
    self.window?.rootViewController = containerController
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}

