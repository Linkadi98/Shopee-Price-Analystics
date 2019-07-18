//
//  RegisterViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/14/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin
import GoogleSignIn

class RegisterViewController: UIViewController {
    // MARK: - Properties
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().signInSilently()        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configInputField(for: userName, icon: #imageLiteral(resourceName: "account"))
        configInputField(for: email, icon: #imageLiteral(resourceName: "email"))
        configInputField(for: password, icon: #imageLiteral(resourceName: "password"))
//        configInputField(for: confirmPassword, icon: <#T##UIImage#>)
    }

    // MARK: - Private modification
    private func configInputField (for textField: UITextField, icon iconImage: UIImage) {
        textField.createUnderlineTextField()
        textField.setIcon(iconImage)
    }

    @IBAction func loginByFb(_ sender: Any) {
        ViewController.loginFb(inViewController: self)
    }

    @IBAction func loginByGg(_ sender: Any) {
//        GIDSignIn.sharedInstance()?.signIn()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Google Sign In
//extension RegisterViewController {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            print("\(error.localizedDescription)")
//        } else {
//            // Perform any operations on signed in user here.
//            //            let userId = user.userID                  // For client-side use only!
//            //            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            //            let givenName = user.profile.givenName
//            //            let familyName = user.profile.familyName
//            //            let email = user.profile.email
//
//            // Google cover picture
//            var pic = ""
//
//            if user.profile.hasImage
//            {
//                pic = user.profile.imageURL(withDimension: 150)!.absoluteString
//            }
//
//            let currentUser = User(name: fullName!, image: pic)
//
//            if let encoded = try? JSONEncoder().encode(currentUser) {
//                UserDefaults.standard.set(encoded, forKey: "currentUser")
//            }
//
//            print("Login Google in Register VC.")
//            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
//            self.present(secondVC, animated: true, completion: nil)
//        }
//    }
//
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
//              withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//        print("\(user.profile.name!) has disconnected!")
//    }
//}
