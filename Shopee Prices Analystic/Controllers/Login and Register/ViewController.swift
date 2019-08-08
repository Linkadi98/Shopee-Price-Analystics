//
//  ViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/12/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import TransitionButton
import GoogleSignIn
import NotificationBannerSwift

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var invalidUserName: UILabel! {
        didSet {
            invalidUserName.text = nil
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // test
        userNameText.text = "thanhduy"
        passwordText.text = "123456"
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginButton.setGrandientColor(colorOne: hexStringToUIColor(hex: "#ffc400"), colorTwo: hexStringToUIColor(hex: "#FF5700"))
        loginButton.spinnerColor = .white
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        
        userNameText.createUnderlineTextField()
        passwordText.createUnderlineTextField()
        
        configCircularButton(for: facebookButton, with: .blue)
        configCircularButton(for: googleButton, with: .orange)
        
        userNameText.setIcon(#imageLiteral(resourceName: "user"))
        passwordText.setIcon(#imageLiteral(resourceName: "password"))
    }
    
    // MARK: - Actions
    
    @IBAction func loginSPA(_ sender: Any) {
        loginButton.startAnimation()

        self.login(username: userNameText.text!, password: passwordText.text!) {
            self.loginButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0, completion: {
                self.loginButton.setGrandientColor(colorOne: self.hexStringToUIColor(hex: "#ffc400"), colorTwo: self.hexStringToUIColor(hex: "#FF5700"))
                self.loginButton.spinnerColor = .white
                self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height / 2
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        }
    }

    @IBAction func loginByFb(_ sender: Any) {
        self.loginFb()
    }


    @IBAction func loginByGg(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func userNameEdittingDidChange(_ sender: Any) {
        if !userNameText.isValidUserName() {
            invalidUserName.text = "Vui lòng nhập tên đăng nhập hoặc email hợp lệ"
        }
        else {
            invalidUserName.text = nil
        }
    }
    
    // MARK: - Private Modifications
    
    func showInvalidMessage(with status: Bool = false, _ sender: TransitionButton) {
        if !status {
            sender.stopAnimation(animationStyle: .normal, revertAfterDelay: 1, completion: {
                self.loginButton.layer.cornerRadius = self.loginButton.frame.height / 2
                let alert = UIAlertController(title: "Đăng nhập không thành công", message: "Sai tên đăng nhập hoặc mật khẩu", preferredStyle: .alert)
                let retyping = UIAlertAction(title: "Nhập lại", style: .default, handler: {(action) in
                    self.passwordText.text = nil
                })
                alert.addAction(retyping)
                alert.popoverPresentationController?.sourceView = self.view
                self.present(alert, animated: true, completion: nil)
            })
        }
            
    }
    
    private func showMainAppicationAfterSuccessfulLogin(with status: Bool = true, _ sender: TransitionButton) {
        if status {
            sender.stopAnimation(animationStyle: .expand, completion: {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
            self.present(secondVC, animated: false, completion: nil)
            })
        }
    }

    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {

    }
}
