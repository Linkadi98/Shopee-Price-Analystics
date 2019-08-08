//
//  AccoutDetailTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/25/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class AccountDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.layer.cornerRadius = avatar.frame.height / 2
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var password: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfoOfAccount()
    }
    
    // MARK: - Actions
    
    @IBAction func logout(_ sender: Any) {
        print("logout6969")
        if UserDefaults.standard.string(forKey: "token") != nil {
            // Delete token
            UserDefaults.standard.removeObject(forKey: "token")
            Network.shared.headers["Authorization"] = nil
        }
        else if AccessToken.current != nil {
            // Logout Fb
            LoginManager().logOut()
        }
        else {
            // Logout Gg
            GIDSignIn.sharedInstance()?.signOut()
        }
        
        // Delete user data in UserDefaults
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "currentShop")

        // Back to login screen
        self.moveVC(viewController: self, toViewControllerHasId: "LoginViewController")
    }
    
    // MARK: - Private modifications
    private func getInfoOfAccount() {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"), let currentUser = try? JSONDecoder().decode(User.self, from: userData) {
            userName.text = currentUser.name!
            
            loadOnlineImage(from: URL(string: currentUser.image!)!, to: self.avatar)
        }
    }
    
    // MARK: - Prepare data
    
    func prepareData(avatar: UIImage?, userName: String?, email: String?, phoneNum: String?, password: String?) {
        self.avatar.image = avatar
        self.userName.text = userName
        self.email.text = email
        self.password.text = password
        print("done")
    }
}
