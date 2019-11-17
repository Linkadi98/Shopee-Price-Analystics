//
//  ViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/12/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import TransitionButton
import FacebookLogin
import FBSDKLoginKit
import SwiftyJSON
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()

        loginButton.setGrandientColor(colorOne: hexStringToUIColor(hex: "#48c6ef"), colorTwo: hexStringToUIColor(hex: "#6f86d6"))
        loginButton.spinnerColor = .white
        loginButton.layer.cornerRadius = 18
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userNameText.createUnderlineTextField()
        passwordText.createUnderlineTextField()
        
        configCircularButton(for: facebookButton, with: .blue)
        configCircularButton(for: googleButton, with: .orange)
        
        userNameText.setIcon(#imageLiteral(resourceName: "user"))
        passwordText.setIcon(#imageLiteral(resourceName: "password"))

        // Signed in Fb
        if AccessToken.current != nil {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
            self.present(secondVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func loginSPA(_ sender: TransitionButton) {
        sender.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(3) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                sender.stopAnimation(animationStyle: .expand, completion: {
                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
                    self.present(secondVC, animated: true, completion: nil)
                })
            })
        })
    }

    @IBAction func loginByFb(_ sender: Any) {
        LoginManager().logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermisson, let accessToken):
                print("\(accessToken) logged in!")
                print("\(grantedPermissions)")
                self.getFbUserData()

                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
                self.present(secondVC, animated: true, completion: nil)
            }
        }
    }


    @IBAction func loginByGg(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }

    @IBAction func unWind(unWindSegue: UIStoryboardSegue) {
        
    }
}

// MARK: - Extension

extension ViewController {
    // MARK: - Private modify functions

    private func hexStringToUIColor (hex: String) -> UIColor {
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

    private func configCircularButton(for button: UIButton, with color: UIColor) {
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 1.0
        button.layer.shadowOpacity = 0.5
        button.layer.cornerRadius = button.frame.width / 2
    }

    func getFbUserData() {
        let connection = GraphRequestConnection()

        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)) { (connection, result, error) in

            let fbDictionary = result as! [String: AnyObject]
            let id = fbDictionary["id"] as! String
            let name = fbDictionary["name"] as! String
            let email = fbDictionary["email"] as! String

            let currentUser = User(name: name, image: "https://graph.facebook.com/\(id)/picture?type=large")

            if let encoded = try? JSONEncoder().encode(currentUser) {
                UserDefaults.standard.set(encoded, forKey: "currentUser")
            }

            print("id = \(id), name = \(name), email = \(email)")
        }
        connection.start()
    }

}

// MARK: - Google Sign In
extension ViewController {
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

            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
            self.present(secondVC, animated: true, completion: nil)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("\(user.profile.name!) has disconnected!")
    }
}

extension UITextField {
    
    open func createUnderlineTextField() {
        print(layer.frame.width)
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: frame.height + 10, width: frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        
        layer.addSublayer(bottomLine)
    }
    
    open func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 5, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}


extension UIButton {
    
    open func setGrandientColor(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    open func setGrandientColor(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor, colorFour: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor, colorThree.cgColor, colorFour.cgColor]
        gradientLayer.locations = [0.0, 0.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    open func setGrandientColor(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor, colorThree.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
