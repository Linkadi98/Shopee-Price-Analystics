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
import FacebookLogin
import GoogleSignIn
import FacebookLogin
import Alamofire

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

//     sửa hàm này khi đã có api trả về trạng thái thành công/không thành công bằng 1 closure
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

            print(id)
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
            
            print("Login Google in \(type(of: self)).")

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
        let userId = user.userID                  // For client-side use only!
        print(userId!)
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

// Get list shop
extension UIViewController {
//    func getListShops(completion: @escaping ([Shop]) -> Void) {
//        let url = URL(string: Config.BASE_URL + Config.SHOP_PATH)!
//
////        let alamofireManager = AlamofireManager(timeoutInterval: 1000).manager
//
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: Config.HEADERS).validate().responseJSON { (response) in
//            guard response.result.isSuccess else {
//                // NEED EDITED
//                let banner = StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger)
//                banner.show()
//
//                print("Error when fetching data: \(response.result.error)")
//                return
//            }
//
//            print("fetching")
//            var listShops: [Shop] = []
//            let responseValue = response.result.value! as! [[String: Any]]
//            print(response.result.value!)
//            for value in responseValue {
//                let shopId = String(value["id"] as! Int64)
//                let shopName = value["name"] as! String
//                listShops.append(Shop(shopId: shopId, shopName: shopName))
//            }
//            completion(listShops)
//        }
//    }
//
//    func addShop(shopId: String, name: String) {
//        let url = URL(string: Config.BASE_URL + Config.SHOP_PATH)!
//        let parameters: Parameters = [
//            "id": shopId,
//            "name": name
//        ]
//
//        let alamofireManager = AlamofireManager(timeoutInterval: 1000).manager
//
//        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding(options: []), headers: Config.HEADERS).validate().responseJSON { (response) in
//            guard response.result.isSuccess else {
//                // NEED EDITED
//                let banner = StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .warning)
//                banner.show()
//                print("Error when fetching data: \(response.result.error)")
//                return
//            }
//
//            print(response.result.value! as! [String: Any])
//        }
//    }
}

// Load online image
extension UIViewController {
    func loadOnlineImage(from url: URL, to uiImageView: UIImageView) {
        DispatchQueue(label: "loadImage").async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    uiImageView.image = UIImage(data: data)
                }
            } catch {
                print("Can't load Image!")
            }
        }
    }
}

// Present a alert
extension UIViewController {
    func presentAlert(title: String = "Lỗi", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)

        self.present(alert, animated: true, completion: nil)
    }
}

// Init an activity indicator
extension UIViewController {
    func initActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.style = .whiteLarge
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .orange

        return activityIndicator
    }
}




