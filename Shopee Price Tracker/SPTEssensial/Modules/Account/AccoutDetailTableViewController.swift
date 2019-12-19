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
    
    let userDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(onInternetAccess(_:)), name: .internetAccess, object: nil)
        
        center.addObserver(self, selector: #selector(onNoInternetAccess(_:)), name: .noInternetAccess, object: nil)
    }
    
    @objc func onInternetAccess(_ notification: Notification) {
       
    }
    
    @objc func onNoInternetAccess(_ notification: Notification) {
        
        presentAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.font = UIFont.systemFont(ofSize: 14.0)
        password.text = "●●●●●●●●"
        
        getAccountInfo()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            changeName()
        case 2:
            changePhoneNumber()
        case 3:
            changePassword()
        default:
            break
        }

        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    // MARK: - Actions
    
    @IBAction func logout(_ sender: Any) {
        self.logout()

        // Back to login screen
        
    }
    
    // MARK: - Private modifications
    private func getAccountInfo() {
        let currentUser = userDefaults.getObjectInUserDefaults(forKey: "currentUser") as! User

        userName.text = currentUser.name
        email.text = currentUser.email
        if let phone = currentUser.phone {
            phoneNumber.text = phone
        } else {
            phoneNumber.text = "Chưa có"
        }

        loadOnlineImageByAlamofire(withName: currentUser.name, to: self.avatar)

//        loadOnlineImage(from: URL(string: currentUser.image)!, to: self.avatar)
    }

    private func changeName() {
        // Configure alerts
        let alert = UIAlertController(title: "Đổi tên", message: "Xác nhận mật khẩu và nhập tên mới:", preferredStyle: .alert)
//        alert.addTextField { (textField) in
//            textField.isSecureTextEntry = true
//            textField.placeholder = "Xác nhận mật khẩu"
//        }
        alert.addTextField { (textField) in
            textField.placeholder = "Nhập tên mới"
        }
        alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            // Handle exceptions
//            let passwordInput = alert.textFields![0].text!
//            let nameInput = alert.textFields![1].text!
            let nameInput = alert.textFields![0].text!
//            guard passwordInput.count > 5 else {
//                self.presentAlert(message: "Không đúng mật khẩu")
//                return
//            }
            guard nameInput != self.userName.text! else {
                self.presentAlert(title: "Thông báo", message: "Thông tin không thay đổi")
                return
            }

            guard nameInput != "" else {
                self.presentAlert(message: "Tên không được để trống")
                return
            }

            // Call API
            let activityIndicator = self.startLoading()

            self.updateInfo(currentPassword: nil, newPassword: nil, name: nameInput, phone: nil, completion: { (result) in
                switch result {
                case .error:
                    self.presentAlert(message: "Mật khẩu không chính xác")
                case .success:
                    var currentUser = self.userDefaults.getObjectInUserDefaults(forKey: "currentUser") as! User
                    currentUser.name = nameInput
                    self.saveObjectInUserDefaults(object: currentUser as AnyObject, forKey: "currentUser")
                    // Change in interface
                    self.userName.text = nameInput
                    self.presentAlert(title: "Thông báo", message: "Thay đổi thành công")
                default:
                    break
                }
                self.endLoading(activityIndicator)
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func changePhoneNumber() {
        // Configure alerts
        let alert = UIAlertController(title: "Đổi số điện thoại", message: "Xác nhận mật khẩu và nhập số điện thoại mới:", preferredStyle: .alert)
//        alert.addTextField { (textField) in
//            textField.borderStyle = .none
//            textField.isSecureTextEntry = true
//            textField.placeholder = "Xác nhận mật khẩu"
//        }
        alert.addTextField { (textField) in
            textField.borderStyle = .none
            textField.keyboardType = .numberPad
            textField.placeholder = "Nhập số điện thoại mới"
        }
        alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            // Handle exceptions
//            let passwordInput = alert.textFields![0].text!
//            let phoneNumberInput = alert.textFields![1].text!
            let phoneNumberInput = alert.textFields![0].text!
//            guard passwordInput.count > 5 else {
//                self.presentAlert(message: "Không đúng mật khẩu")
//                return
//            }
            guard phoneNumberInput != self.phoneNumber.text! else {
                self.presentAlert(title: "Thông báo", message: "Thông tin không thay đổi")
                return
            }

            guard let _ = Int(phoneNumberInput), phoneNumberInput.hasPrefix("0"), phoneNumberInput.count == 10 else {
                self.presentAlert(message: "Vui lòng nhập số điện thoại chính xác")
                return
            }

            // Call API
            let activityIndicator = self.startLoading()

            self.updateInfo(currentPassword: nil, newPassword: nil, name: nil, phone: phoneNumberInput, completion: { (result) in
                switch result {
                case .error:
                    self.presentAlert(message: "Mật khẩu không chính xác")
                case .success:
                    var currentUser = self.userDefaults.getObjectInUserDefaults(forKey: "currentUser") as! User
                    currentUser.phone = phoneNumberInput
                    self.saveObjectInUserDefaults(object: currentUser as AnyObject, forKey: "currentUser")
                    // Change in interface
                    self.phoneNumber.text = phoneNumberInput
                    self.presentAlert(title: "Thông báo", message: "Thay đổi thành công")
                default:
                    break
                }
                self.endLoading(activityIndicator)
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func changePassword() {
        // Configure alert
        let alert = UIAlertController(title: "Đổi mật khẩu", message: "Hãy nhập mật khẩu", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.borderStyle = .none
            textfield.isSecureTextEntry = true
            textfield.placeholder = "Mật khẩu hiện tại"
        }
        alert.addTextField { (textfield) in
            textfield.borderStyle = .none
            textfield.isSecureTextEntry = true
            textfield.placeholder = "Mật khẩu mới"
        }
        alert.addTextField { (textfield) in
            textfield.borderStyle = .none
            textfield.isSecureTextEntry = true
            textfield.placeholder = "Xác nhận mật khẩu"
        }
        
       
        alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            // Handle exceptions
            let currentPasswordInput = alert.textFields![0].text!
            let newPasswordInput = alert.textFields![1].text!
            let rePasswordInput = alert.textFields![2].text!
            guard newPasswordInput == rePasswordInput else {
                self.presentAlert(message: "Xác nhận mật khẩu không khớp")
                return
            }

            guard newPasswordInput.count > 5 else {
                self.presentAlert(message: "Mật khẩu bao gồm tối thiểu 6 ký tự")
                return
            }

            guard currentPasswordInput.count > 5 else {
                self.presentAlert(message: "Không đúng mật khẩu hiện tại")
                return
            }

            // Call API
            let activityIndicator = self.startLoading()

            self.updateInfo(currentPassword: currentPasswordInput, newPassword: newPasswordInput, name: nil, phone: nil, completion: { (result) in
                switch result {
                case .error:
                    self.presentAlert(message: "Mật khẩu hiện tại không chính xác")
                case .success:
                    self.presentAlert(title: "Thông báo", message: "Đổi mật khẩu thành công")
                default:
                    break
                }
                self.endLoading(activityIndicator)
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func logout() {
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
}
