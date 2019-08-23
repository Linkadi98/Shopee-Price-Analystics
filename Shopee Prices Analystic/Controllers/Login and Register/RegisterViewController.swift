//
//  RegisterViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/14/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import GoogleSignIn
import TransitionButton
import Alamofire
import NotificationBannerSwift

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var userNameHint: UILabel!
    @IBOutlet weak var emailHint: UILabel!
    @IBOutlet weak var passwordHint: UILabel!
    @IBOutlet weak var confirmPasswordHint: UILabel!
    
    @IBOutlet weak var registerButton: TransitionButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        changeRegisterButtonColor()
//        registerButton.isEnabled = false
//        registerButton.backgroundColor = .gray

        hideKeyboardWhenTappedAround()
        registerKeyboardForNotification()
        
        configLabelHint(hints: passwordHint, confirmPasswordHint, emailHint, userNameHint)
        
        // Do any additional setup after loading the view.
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configIconTextField(for: userName, icon: #imageLiteral(resourceName: "user"))
        configIconTextField(for: email, icon: #imageLiteral(resourceName: "email"))
        configIconTextField(for: password, icon: #imageLiteral(resourceName: "password"))
        configIconTextField(for: confirmPassword, icon: #imageLiteral(resourceName: "password"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        drawUnderline(for: userName, email, password, confirmPassword)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyBoard(userName, email, password, confirmPassword)
        return true
    }
    
    // MARK: - Text Configs
    @IBAction func userNameEditingChanged(_ sender: Any) {
        if !userName.isValidUserNameRegister() {
            userNameHint.text = "Tên đăng nhập viết liền không dấu, ít nhất 6 ký tự"
        }
        else {
            userNameHint.text = nil
        }

        changeRegisterButtonColor()
    }
    
    @IBAction func emailEditingChanged(_ sender: Any) {
        print(email.text!)
        if !email.isValidEmail() {
            emailHint.text = "Vui lòng nhập đúng email"
        }
        else {
            emailHint.text = nil
        }

        changeRegisterButtonColor()
    }
    
    @IBAction func passwordEditingChanged(_ sender: Any) {
        print(password.text!)
        if !password.isValidPassword() {
            passwordHint.text = "Mật khẩu phải có ít nhất 6 kí tự"
        }
        else {
            passwordHint.text = nil
        }

        changeRegisterButtonColor()
    }
    
    @IBAction func confirmEditingChanged(_ sender: Any) {
        if !confirmPassword.confirmPassword(to: password.text!) {
            confirmPasswordHint.text = "Mật khẩu xác nhận chưa đúng"
        }
        else {
            confirmPasswordHint.text = nil
        }

        changeRegisterButtonColor()
    }

    // Register SPA account
    @IBAction func register(_ sender: Any) {
        let activityIndicator = startLoading()

        register(name: "Thanh Duy Truong", phone: nil, email: email.text!, username: userName.text!, password: password.text!) { (result) in
            switch result {
            case .error:
                self.presentAlert(message: "Email hoặc tài khoản đã tồn tại")
            case .success:
                // Screen movement
                self.performSegue(withIdentifier: "RegisterVCToTabsVC", sender: nil)
            default:
                break
            }
            
            self.endLoading(activityIndicator)
        }
    }
    // Log in using facebook account
    @IBAction func loginByFb(_ sender: Any) {
        self.loginFb()
    }

    @IBAction func loginByGg(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // MARK: - Private modification
    private func configIconTextField(for textfield: UITextField, icon iconImage: UIImage) {
        textfield.setIcon(iconImage)
    }
    
    private func drawUnderline(for textfields: UITextField...) {
        for textfield in textfields {
            textfield.createUnderlineTextField()
        }
    }
    
    private func hideKeyBoard(_ textFields: UITextField...) {
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    private func configLabelHint(hints: UILabel...) {
        for hint in hints {
            hint.text = nil
            hint.textColor = UIColor.red
        }
    }
    
    // MARK: - Keyboard issues
    func registerKeyboardForNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillbeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    @objc func keyboardWasShown(notification: Notification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else {
                return
        }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillbeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

}

// Check registering
extension RegisterViewController {
    func isValidRegister() -> Bool {
        if userName.isValidUserNameRegister() && email.isValidEmail() && password.isValidPassword() && confirmPassword.confirmPassword(to: password.text!) {
            return true
        }

        return false
    }

    func changeRegisterButtonColor() {
        if isValidRegister() {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .blue
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .gray
        }
    }
}


