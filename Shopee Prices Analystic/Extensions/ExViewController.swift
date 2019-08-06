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
    func login(username: String, password: String) {
        let url = URL(string: Config.BASE_URL + Config.LOGIN_PATH)!
        let parameters: Parameters = [
            "username" : username,
            "password" : password
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding(options: []), headers: Config.HEADERS).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
                // TO BE DONE
                print("Error when fetching data: \(response.result.error)")
                return
            }

            let responseValue = response.result.value! as! [String: Any]
            let token = responseValue["token"] as! String
            print(token)
            UserDefaults.standard.set(token, forKey: "token")
            Config.HEADERS["Authorization"] = token

            let currentUser = User(name: username, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQereh1OeQmTjzhj_oUwdr0gPkv5vcBk1lSv8xGx4e00Eg1ob42") // NEED EDITED

            // lưu currentUser trong UserDefaults
            if let encoded = try? JSONEncoder().encode(currentUser) {
                UserDefaults.standard.set(encoded, forKey: "currentUser")
            }

            // Screen movement
            self.moveVC(viewController: self, toViewControllerHasId: "TabsViewController")        
        }
    }
}
