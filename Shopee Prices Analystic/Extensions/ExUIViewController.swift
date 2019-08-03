//
//  EUIViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/20/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import FBSDKLoginKit
import GoogleSignIn
import FacebookLogin

extension UIViewController {
    
    
    // MARK: - Hide keyboard when user tap on screen
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func notification(title: String, style: BannerStyle, status: @escaping () -> Void) {

        let banner = FloatingNotificationBanner(title: title,
                                                subtitle: "Bấm vào đây để kết nối",
                                                style: .warning)
        banner.onTap = {
            status()
            self.tabBarController?.selectedIndex = 4
        }
        
        banner.show(queuePosition: .back,
                    bannerPosition: .top,
                    cornerRadius: 10)
    }
    
    // sửa hàm này khi đã có api trả về trạng thái thành công/không thành công bằng 1 closure
    func statusNotification(title: String, style: BannerStyle) {
        let banner = StatusBarNotificationBanner(title: title, style: style)
        banner.show(queuePosition: .back, bannerPosition: .top)
    }
}

private class BannerStatusColor: BannerColorsProtocol {
    func color(for style: BannerStyle) -> UIColor {
        let color = UIColor.green
        return color
    }
}

// Move View Controller
extension UIViewController {
    func moveVC(viewController: UIViewController, toViewControllerHasId idVC: String) {
        let secondVC = (viewController.storyboard?.instantiateViewController(withIdentifier: idVC))!
        viewController.present(secondVC, animated: true, completion: nil)
    }
}

// Đăng nhập bằng Fb
extension UIViewController {

    // Đăng nhập fb và lưu dữ liệu tài khoản fb
    // Chỉ được gọi khi đăng nhập mới, ko được gọi nếu nhớ tài khoản
    func loginFb() {
        LoginManager().logIn(permissions: [.publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermisson, let accessToken):
                self.getFbUserData() // Lấy dữ liệu tài khoản fb hiện tại
                self.moveVC(viewController: self, toViewControllerHasId: "TabsViewController")
            }
        }
    }

    // Lấy dữ liệu tài khoản fb hiện tại và lưu trong UserDefaults
    func getFbUserData() {
        let connection = GraphRequestConnection()

        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)) { (connection, result, error) in

            let fbDictionary = result as! [String: AnyObject]
            let id = fbDictionary["id"] as! String
            let name = fbDictionary["name"] as! String
            //            let email = fbDictionary["email"] as! String

            let currentUser = User(name: name, image: "https://graph.facebook.com/\(id)/picture?type=large")

            // lưu currentUser trong UserDefaults
            if let encoded = try? JSONEncoder().encode(currentUser) {
                UserDefaults.standard.set(encoded, forKey: "currentUser")
            }
        }
        connection.start()
    }
}

// Login Google
extension UIViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    // must implement
    // Được gọi cả khi đăng nhập mới (ko phải nhớ tài khoản)
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            getGgUserData(of: user) // Lưu dữ liệu tài khoản Gg
            
            print("Login Google in RegisterVC.")

            // Screen movement
            self.moveVC(viewController: self, toViewControllerHasId: "TabsViewController")
        }
    }

    // must implement
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("\(user.profile.name!) has disconnected!")
    }

    // Lấy dữ liệu tài khoản Google và lưu vào UserDefaults
    func getGgUserData(of user: GIDGoogleUser!) {
        // Perform any operations on signed in user here.
        //            let userId = user.userID                  // For client-side use only!
        //            let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        //            let givenName = user.profile.givenName
        //            let familyName = user.profile.familyName
        //            let email = user.profile.email

        // Google cover picture
        var pic = ""
        if user.profile.hasImage
        {
            pic = user.profile.imageURL(withDimension: 150)!.absoluteString
        }

        let currentUser = User(name: fullName!, image: pic)

        if let encoded = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
}
