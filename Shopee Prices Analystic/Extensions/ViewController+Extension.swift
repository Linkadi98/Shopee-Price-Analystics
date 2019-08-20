//
//  ViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/20/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Alamofire
import NotificationBannerSwift
import TransitionButton

extension ViewController {
    
    // MARK: - Modifications
    
    open func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    open func configCircularButton(for button: UIButton, with color: UIColor) {
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 1.0
        button.layer.shadowOpacity = 0.5
        button.layer.cornerRadius = button.frame.width / 2
    }
}

// Login by SPA Account
extension ViewController {
    func login(username: String, password: String, completion: @escaping () -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.login_path)!
        let parameters: Parameters = [
            "username" : username,
            "password" : password
        ]

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: parameters).validate().responseJSON { (response) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Failed request
                guard response.result.isSuccess else {
                    print("Error when fetching data: \(response.result.error)")
                    StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                    completion()
                    return
                }

                //Successful request
                let responseValue = response.result.value! as! [String: Any]
                print(responseValue)
                guard let token = responseValue["token"] as? String else {
                    self.presentAlert(message: "Sai tài khoản hoặc mật khẩu")
                    completion()
                    return
                }

                // Save token and its expired time
                print(token)
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(Date(timeIntervalSinceNow: 21600), forKey: "expiredTimeOfToken")
                sharedNetwork.headers["Authorization"] = token

                self.getInfo(username: username) {
                    completion()
                }
                
                // Screen movement
                self.performSegue(withIdentifier: "VCToTabsVC", sender: nil)
            }
        }
    }

    func forget(email: String, completion: @escaping () -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.forget_path)!
        let parameters: Parameters = [
            "email" : email
        ]

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: parameters).validate().responseString { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion()
                return
            }

            //Successful request
            let responseValue = response.result.value!
            if responseValue == "mail lỗi" {
                self.presentAlert(message: "Mail không chính xác")
            } else if responseValue == "Đề nghị check mail" {
                self.presentAlert(title: "Thông báo", message: "Mở mail để nhận mật khẩu mới")
            }
            completion()
        }
    }
}
