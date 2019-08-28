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
        userNameText.text = "TrongCanh"
        passwordText.text = "123456789"
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loginButton.setGrandientColor(colorOne: hexStringToUIColor(hex: "#ffc400"), colorTwo: hexStringToUIColor(hex: "#FF5700"))
        loginButton.spinnerColor = .white
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        
        
        
        configCircularButton(for: facebookButton, with: .blue)
        configCircularButton(for: googleButton, with: .orange)
        
        userNameText.setIcon(#imageLiteral(resourceName: "user"))
        passwordText.setIcon(#imageLiteral(resourceName: "password"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userNameText.createUnderlineTextField()
        passwordText.createUnderlineTextField()
    }
    
    // MARK: - Actions
    
    @IBAction func loginSPA(_ sender: Any) {
        UIApplication.shared.beginIgnoringInteractionEvents()

        loginButton.startAnimation()
        self.login(username: userNameText.text!, password: passwordText.text!) { result in
            self.loginButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0) {
                self.loginButton.setGrandientColor(colorOne: self.hexStringToUIColor(hex: "#ffc400"), colorTwo: self.hexStringToUIColor(hex: "#FF5700"))
                self.loginButton.spinnerColor = .white
                self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height / 2
                UIApplication.shared.endIgnoringInteractionEvents()
            }

            switch result {
            case .error:
                self.presentAlert(message: "Sai tài khoản hoặc mật khẩu")
            case .success:
                // Screen movement
                
                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: TabsViewController.self)) as! TabsViewController
                
                tabVC.modalTransitionStyle = .crossDissolve
                self.present(tabVC, animated: true, completion: nil)
                NotificationCenter.default.post(name: .didSignedInApp, object: nil)
            default:
                break
            }
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

    @IBAction func forgetAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Lấy lại mật khẩu", message: "Hãy nhập mail:", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "example@abcxyz.com"
        }
        alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let activityIndicator = self.startLoading()

            self.forget(email: alert.textFields![0].text!, completion: { result in
                switch result {
                case .error:
                    self.presentAlert(message: "Mail không chính xác")
                case .success:
                    self.presentAlert(title: "Thông báo", message: "Mở mail để nhận mật khẩu mới")
                default:
                    break
                }
                
              self.endLoading(activityIndicator)
            })
        }))
        self.present(alert, animated: true, completion: nil)
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

    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {

    }
}
