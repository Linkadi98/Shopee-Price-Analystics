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

        
    }

    override func viewWillAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginButton.setGrandientColor(colorOne: hexStringToUIColor(hex: "#48c6ef"), colorTwo: hexStringToUIColor(hex: "#6f86d6"))
        loginButton.spinnerColor = .white
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        
        userNameText.createUnderlineTextField()
        passwordText.createUnderlineTextField()
        
        configCircularButton(for: facebookButton, with: .blue)
        configCircularButton(for: googleButton, with: .orange)
        
        userNameText.setIcon(#imageLiteral(resourceName: "user"))
        passwordText.setIcon(#imageLiteral(resourceName: "password"))

        // Signed in Fb
        if AccessToken.current != nil {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
            self.present(secondVC, animated: false, completion: nil)
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
        ViewController.loginFb(inViewController: self)
    }


    @IBAction func loginByGg(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }

    @IBAction func unWind(unWindSegue: UIStoryboardSegue) {
        
    }
}
