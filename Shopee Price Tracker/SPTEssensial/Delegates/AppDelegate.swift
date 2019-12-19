//
//  AppDelegate.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/12/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn

import SwipeableTabBarController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInUIDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var connectivity: SPTConnectivityHelper?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance()?.clientID = "807535666611-p6k6qk93nmkg0o5t082em63odlr56s6n.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.signInSilently() // Remember Google account

        // Change initial view controller after successful login
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        

        if UserDefaults.standard.object(forKey: "currentUser") != nil {
            // already logged in
            if let token = UserDefaults.standard.string(forKey: "token") {
                if let expiredTimeOfToken = UserDefaults.standard.object(forKey: "expiredTimeOfToken") as? Date {
                    if Date() <= expiredTimeOfToken {
                        // token's not expired -> no need to login
                        Network.shared.headers["Authorization"] = token
                        self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
                        print("App starts in TabsViewController")
                    } else {
                        UserDefaults.standard.removeObject(forKey: "currentUser")
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.removeObject(forKey: "expiredTimeOfToken")
                        self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                    }
                }
            }
        }
        else {
            self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
        }
        
        
        
        self.window?.makeKeyAndVisible()
        
        connectivity = SPTConnectivityHelper()
        connectivity?.invoke()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        connectivity?.destroy()
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
        connectivity?.invoke()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        connectivity?.destroy()
    }
}

extension AppDelegate {
    // must implement
    // Được gọi khi nhớ tài khoản
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            getGgUserData(of: user)

            print("Login Google in AppDelegate.")
        }
    }

    // must implement
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("\(user.profile.name!) has disconnected!")
    }

    // Lấy dữ liệu tài khoản Google và lưu vào UserDefaults
    func getGgUserData(of user: GIDGoogleUser!) {
        // Perform any operations on signed in user here.
        //            let userId = user.userID                  // For client-side use only!
        //            let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        //            let givenName = user.profile.givenName
        //            let familyName = user.profile.familyName
        let email = user.profile.email

        // Google cover picture
        var pic = ""
        if user.profile.hasImage
        {
            pic = user.profile.imageURL(withDimension: 150)!.absoluteString
        }

        let currentUser = User(userName: nil, email: email!, name: fullName!, image: pic, phone: nil)

        if let encoded = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
}

