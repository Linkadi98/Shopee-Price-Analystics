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
        print("logout")
        if AccessToken.current != nil {
            // Logout Fb
            LoginManager().logOut()
        } else {
            // Logout Gg
            GIDSignIn.sharedInstance()?.signOut()
        }
        
        // Delete user data in UserDefaults
        UserDefaults.standard.removeObject(forKey: "currentUser")
        // Back to login screen
        self.moveVC(viewController: self, toViewControllerHasId: "LoginViewController")
    }
    
    // MARK: - Private modifications
    private func getInfoOfAccount() {
        var avatar: UIImage?
        var userName: String?
        var email: String?
        var phoneNum: String?
        var password: String?
        
        if let userData = UserDefaults.standard.data(forKey: "currentUser"), let currentUser = try? JSONDecoder().decode(User.self, from: userData) {
            userName = currentUser.name!
            
            DispatchQueue(label: "loadAvatar").async {
                do {
                    let data = try Data(contentsOf:URL(string: currentUser.image!)!)
                    avatar = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.avatar.image = avatar
                    }
                } catch {
                    print("Can't load Avatar!")
                }
            }
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
