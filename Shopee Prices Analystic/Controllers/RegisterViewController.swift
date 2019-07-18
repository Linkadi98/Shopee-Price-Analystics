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

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var keyboardHeight  = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmPassword.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.registerKeyboardForNotification()
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("text is editting")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyBoard(userName, email, password, confirmPassword)
        return true
    }

// Log in using facebook account
    @IBAction func loginByFb(_ sender: Any) {
        LoginManager().logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, _, let accessToken):
                print("\(accessToken) logged in!")
                print("\(grantedPermissions)")
                ViewController().getFbUserData()

                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
                self.present(secondVC, animated: true, completion: nil)
            }
        }
    }

    @IBAction func loginByGg(_ sender: Any) {

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

    // MARK: - Extension

extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
