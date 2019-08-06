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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInUIDelegate, GIDSignInDelegate {

    var window: UIWindow?

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
        var initialViewController: UIViewController
        print("Change initial view controller after successful login")

        if UserDefaults.standard.object(forKey: "currentUser") != nil //your condition if user is already logged in or not
        {
            // if already logged in then redirect to MainViewController
            // save token to HEADERS
            if let token = UserDefaults.standard.string(forKey: "token") {
                Config.HEADERS["Authorization"] = token
            }
            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController // 'MainController' is the storyboard id of MainViewController
        }
        else
        {
            //If not logged in then show LoginViewController
            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController // 'LoginController' is the storyboard id of LoginViewController

        }

        self.window?.rootViewController = initialViewController

        self.window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
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
        //            let email = user.profile.email

        // Google cover picture
        var pic = ""
        if user.profile.hasImage
        {
            pic = user.profile.imageURL(withDimension: 150)!.absoluteString
        }

        let currentUser = User(name: fullName!, image: pic)

        if let encoded = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
}
