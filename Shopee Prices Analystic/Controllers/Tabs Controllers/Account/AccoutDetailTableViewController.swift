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
        password.text = "●●●●●●●●"
        
        getInfoOfAccount()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let alert = UIAlertController(title: "Đổi số điện thoại", message: "Hãy nhập số điện thoại:", preferredStyle: .alert)
            alert.addTextField { (textfield) in
                textfield.text = self.phoneNumber.text!
            }
            alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                guard alert.textFields![0].text! != self.phoneNumber.text! else {
                    self.presentAlert(title: "Thay đổi thất bại", message: "Thông tin không thay đổi")
                    return
                }

                guard let _ = Int(alert.textFields![0].text!) else {
                    self.presentAlert(title: "Thay đổi thất bại", message: "Vui lòng nhập chính xác")
                    return
                }

                UIApplication.shared.beginIgnoringInteractionEvents()

                let activityIndicator = self.initActivityIndicator()
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                self.updateInfo(phone: alert.textFields![0].text!, password: "", completion: { result in
                    if result == "success" {
                        if let userData = UserDefaults.standard.data(forKey: "currentUser"), var currentUser = try? JSONDecoder().decode(User.self, from: userData) {
                            currentUser.phone = alert.textFields![0].text!
                            if let encoded = try? JSONEncoder().encode(currentUser) {
                                UserDefaults.standard.set(encoded, forKey: "currentUser")
                            }
                        }
                        self.phoneNumber.text! = alert.textFields![0].text!
                        self.presentAlert(title: "Thông báo", message: "Cập nhật số điện thoại thành công")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        activityIndicator.stopAnimating()
                        if activityIndicator.isAnimating == false {
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    }
                })
            }))
            self.present(alert, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            let alert = UIAlertController(title: "Đổi mật khẩu", message: "Hãy nhập mật khẩu", preferredStyle: .alert)
            alert.addTextField { (textfield) in
                textfield.isSecureTextEntry = true
                textfield.placeholder = "Mật khẩu"
            }
            alert.addTextField { (textfield) in
                textfield.isSecureTextEntry = true
                textfield.placeholder = "Mật khẩu mới"
            }
            alert.addTextField { (textfield) in
                textfield.isSecureTextEntry = true
                textfield.placeholder = "Xác nhận mật khẩu"
            }
            alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                guard alert.textFields![0].text! == alert.textFields![1].text! else {
                    self.presentAlert(title: "Thay đổi thất bại", message: "Xác nhận mật khẩu không khớp")
                    return
                }

                guard alert.textFields![2].text!.count > 5 else {
                    self.presentAlert(title: "Thay đổi thất bại", message: "Mật khẩu bao gồm tối thiểu 6 ký tự")
                    return
                }

                UIApplication.shared.beginIgnoringInteractionEvents()

                let activityIndicator = self.initActivityIndicator()
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()

                if let currentUserData = UserDefaults.standard.data(forKey: "currentUser"), let currentUser = try? JSONDecoder().decode(User.self, from: currentUserData) {
                    self.checkAccount(username: currentUser.name!, password: alert.textFields![0].text!, completion: { result in
                        if result == "wrong" {
                            self.presentAlert(message: "Sai mật khẩu")
                        } else if result == "success" {
                            self.updateInfo(phone: "", password: alert.textFields![2].text!, completion: { result in
                                if result == "success" {
                                    if let userData = UserDefaults.standard.data(forKey: "currentUser"), var currentUser = try? JSONDecoder().decode(User.self, from: userData) {
                                        currentUser.phone = alert.textFields![0].text!
                                        if let encoded = try? JSONEncoder().encode(currentUser) {
                                            UserDefaults.standard.set(encoded, forKey: "currentUser")
                                        }
                                    }
                                    self.presentAlert(title: "Thông báo", message: "Đổi mật khẩu thành công")
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                                    activityIndicator.stopAnimating()
                                    if activityIndicator.isAnimating == false {
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                    }
                                }
                            })
                        }
                    })
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func logout(_ sender: Any) {
        self.logout()

        // Back to login screen
        self.moveVC(viewController: self, toViewControllerHasId: "LoginViewController")
    }
    
    // MARK: - Private modifications
    private func getInfoOfAccount() {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"), let currentUser = try? JSONDecoder().decode(User.self, from: userData) {
            userName.text = currentUser.name!
            email.text = currentUser.email!
            phoneNumber.text = currentUser.phone!
            
            loadOnlineImage(from: URL(string: currentUser.image!)!, to: self.avatar)
        }
    }

    func logout() {
        print("logout6969")
        if UserDefaults.standard.string(forKey: "token") != nil {
            // Delete token
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "expiredTimeOfToken")
            Network.shared.headers["Authorization"] = nil
        } else if AccessToken.current != nil {
            // Logout Fb
            LoginManager().logOut()
        } else {
            // Logout Gg
            GIDSignIn.sharedInstance()?.signOut()
        }

        // Delete user data in UserDefaults
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "currentShop")
    }

    static func forceloggingout() {
        print("logout6969")
        if UserDefaults.standard.string(forKey: "token") != nil {
            // Delete token
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "expiredTimeOfToken")
            Network.shared.headers["Authorization"] = nil
        } else if AccessToken.current != nil {
            // Logout Fb
            LoginManager().logOut()
        } else {
            // Logout Gg
            GIDSignIn.sharedInstance()?.signOut()
        }

        // Delete user data in UserDefaults
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "currentShop")
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
