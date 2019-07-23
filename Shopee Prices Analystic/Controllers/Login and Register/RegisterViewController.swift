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

class RegisterViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
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
            userNameHint.text = "Tên đăng nhập phải có ít nhất 5 kí tự"
        }
        else {
            userNameHint.text = nil
        }
    }
    
    @IBAction func emailEditingChanged(_ sender: Any) {
        print(email.text!)
        if !email.isValidEmail() {
            emailHint.text = "Vui lòng nhập đúng email"
        }
        else {
            emailHint.text = nil
        }
    }
    
    @IBAction func passwordEditingChanged(_ sender: Any) {
        print(password.text!)
        if !password.isValidPassword() {
            passwordHint.text = "Mật khẩu phải có ít nhất 6 kí tự"
        }
        else {
            passwordHint.text = nil
        }
    }
    
    @IBAction func confirmEditingChanged(_ sender: Any) {
        if !confirmPassword.confirmPassword(to: password.text!) {
            confirmPasswordHint.text = "Mật khẩu xác nhận chưa đúng"
        }
        else {
            confirmPasswordHint.text = nil
        }
    }
    
    // Log in using facebook account
    @IBAction func loginByFb(_ sender: Any) {
        ViewController.loginFb(inViewController: self)
    }

    @IBAction func loginByGg(_ sender: Any) {
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

// Login Google
// Đăng nhập Google ở VC nào thì phải implement 2 hàm sign ở đó, còn với Facebook có thể gọi static func loginFb trong ViewController (trong button loginByFb ở trên)
extension RegisterViewController {
    // must implement (gọi static func trong AppDelegate) để rút gọn code???
    // Đăng nhập gg và lưu dữ liệu tài khoản gg
    // Được gọi cả khi đăng nhập mới và nhớ tài khoản
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            AppDelegate.sign(didSignInFor: user, withError: error)
            print("Login Google in RegisterVC.")
            // Screen movement
            ViewController.move(viewController: self, toViewControllerHasId: "TabsViewController")
        }
    }

    // must implement
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("\(user.profile.name!) has disconnected!")
        }
}


