//
//  AppDelegate.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/20/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "sgvbikes"
                configuration.clientKey = "com.sandoval.sgvBikes"  // set to nil assuming you have not set clientKey
                configuration.server = "http://fathomless-journey-79850.herokuapp.com/parse"
            })
        )
        
        // check if user is logged in.
        if PFUser.current() != nil {
            // if there is a logged in user then load the home view controller
            //Use the navigation controller because it contains the tab bar controller and leads to the homeView (storyboard of ID) of the HomeViewController
            let loggedInViewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "appHome")
            self.window?.rootViewController = loggedInViewController
            print("By: AppDelegate.swift \n --------> User still logged in.")
            UserInstance.loadUser(PFUser.current()!)
        }
        
        GMSServices.provideAPIKey("AIzaSyCOzpPnHzy0Ihq6YNpN_aIF6z7wd0bcIpQ")
        
        return true
    }
    


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

