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

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
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
        LoginManager().logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermisson, let accessToken):
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
