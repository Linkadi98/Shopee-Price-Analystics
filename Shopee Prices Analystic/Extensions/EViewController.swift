//
//  ViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/20/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn


extension ViewController {
    
    // MARK: - Modifications
    
    open func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    open func configCircularButton(for button: UIButton, with color: UIColor) {
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 1.0
        button.layer.shadowOpacity = 0.5
        button.layer.cornerRadius = button.frame.width / 2
    }
    
    
    // MARK: - Google Sign In
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
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
            
            print("Login Google in VC.")
            
            //            let secondVC = (self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController"))!
            //            self.present(secondVC, animated: true, completion: nil)
            ViewController.move(viewController: self, toViewControllerHasId: "TabsViewController")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("\(user.profile.name!) has disconnected!")
    }
    
    static func move(viewController: UIViewController, toViewControllerHasId idVC: String) {
        let secondVC = (viewController.storyboard?.instantiateViewController(withIdentifier: idVC))!
        viewController.present(secondVC, animated: true, completion: nil)
    }
    
    // Đăng nhập bằng fb + gg
    
    // Đăng nhập bb và lưu dữ liệu tài khoản fb
    // Chỉ được gọi khi đăng nhập mới, ko được gọi nếu nhớ tài khoản
    static func loginFb(inViewController viewController: UIViewController) {
        LoginManager().logIn(permissions: [.publicProfile, .email], viewController: viewController) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermisson, let accessToken):
                ViewController.getFbUserData()
                ViewController.move(viewController: viewController, toViewControllerHasId: "TabsViewController")
            }
        }
    }
    
    // Lấy dữ liệu tài khoản fb hiện tại và lưu trong UserDefaults
    static func getFbUserData() {
        let connection = GraphRequestConnection()
        
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)) { (connection, result, error) in
            
            let fbDictionary = result as! [String: AnyObject]
            let id = fbDictionary["id"] as! String
            let name = fbDictionary["name"] as! String
            //            let email = fbDictionary["email"] as! String
            
            let currentUser = User(name: name, image: "https://graph.facebook.com/\(id)/picture?type=large")
            
            // lưu currentUser trong UserDefaults
            if let encoded = try? JSONEncoder().encode(currentUser) {
                UserDefaults.standard.set(encoded, forKey: "currentUser")
            }
        }
        connection.start()
    }
}
