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

extension UIViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
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


    func statusNotification(title: String, style: BannerStyle) {
        let banner = StatusBarNotificationBanner(title: title, style: style)
        banner.show(queuePosition: .back, bannerPosition: .top)
    }

    // Move View Controller
    
    func moveVC(viewController: UIViewController, toViewControllerHasId idVC: String) {
        let secondVC = (viewController.storyboard?.instantiateViewController(withIdentifier: idVC))!
        viewController.present(secondVC, animated: true, completion: nil)
    }

    // Đăng nhập bằng Fb
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

    // Login Google
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


    // Get list shop

    func getListShops(completion: @escaping ([Shop]?) -> Void) {
        let sharedNetwork = Network.shared
        // let url = URL(string: "http://192.168.10.8:3000" + sharedNetwork.shop_path)!
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.shop_path)!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion(nil)
                return
            }

            //Successful request
            var listShops: [Shop] = []
            print(response.result.value)
            let responseValue = response.result.value! as! [[String: Any]]
            print(responseValue)
            for value in responseValue {
                let shopId = String(value["id"] as! Int64)
                let shopName = value["name"] as! String
                listShops.append(Shop(shopId: shopId, shopName: shopName))
            }

            if listShops.isEmpty {
                UserDefaults.standard.removeObject(forKey: "currentShop")
                let banner = FloatingNotificationBanner(title: "Chưa kết nối đến cửa hàng nào",
                                                        subtitle: "Bấm vào đây để kết nối",
                                                        style: .warning)
                banner.onTap = {
                    self.tabBarController?.selectedIndex = 4
                }
                banner.show(queuePosition: .back,
                            bannerPosition: .top,
                            cornerRadius: 10)
            } else {
                // Case: didn't save currentShop before, save first shop in list shops
                guard let savedCurrentShopData = UserDefaults.standard.data(forKey: "currentShop") else {
                    if let encoded = try? JSONEncoder().encode(listShops[0]) {
                        UserDefaults.standard.set(encoded, forKey: "currentShop")
                    }
                    completion(listShops)
                    return
                }

                // Case: save currentShop before
                // Decode
                var savedCurrentShop = try! JSONDecoder().decode(Shop.self, from: savedCurrentShopData)

                // Check if listShop contains savedCurrentShop
                // if listShop contains savedCurrentShop, currentShop isn't changed
                if listShops.contains(savedCurrentShop) {
                    completion(listShops)
                    return
                }

                // listShop doesn't contain savedCurrentShop
                for shop in listShops {
                    // but maybe shop was changed its name (not deleted)
                    if savedCurrentShop.shopId == shop.shopId {
                        savedCurrentShop = shop
                        if let encoded = try? JSONEncoder().encode(savedCurrentShop) {
                            UserDefaults.standard.set(encoded, forKey: "currentShop")
                        }
                        completion(listShops)
                        return
                    }
                }
            }
            completion(listShops)
        }
    }

    func addShop(shopId: String, shopName: String, completion: @escaping (String) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.shop_path)!
        let parameters: Parameters = [
            "id": shopId,
            "name": shopName
        ]

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: parameters).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion("failed")
                return
            }

            //Successful request
            let responseValue = response.result.value!
            print(responseValue)
            completion("success")
        }
    }

    // get list products from DB
    func getListProducts(completion: @escaping ([Product]?) -> Void) {
        let sharedNetwork = Network.shared
        //        let url = URL(string: "http://192.168.10.8:3000" + sharedNetwork.shop_path)!
        var url = URL(string: "https://google.com")!
        if let currentShopData = UserDefaults.standard.data(forKey: "currentShop") {
            if let currentShop = try? JSONDecoder().decode(Shop.self, from: currentShopData) {
                url = URL(string: sharedNetwork.base_url + sharedNetwork.items_path + "/\(currentShop.shopId)")!
            }
        } else {
            print("Chua co san pham vi chua ket noi cua hang")
        }

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion(nil)
                return
            }

            //Successful request
            var listProducts: [Product] = []
            print(response.result.value)
            let responseValue = response.result.value! as! [[String: Any]]
            print(responseValue)
            for value in responseValue {
                let id = String(value["item_id"] as! Int)
                let name = value["name"] as! String
                let price = Int(value["price"] as! Double)
                let image = (value["images"] as! [String])[0]
                listProducts.append(Product(id: id, name: name, price: price, rating: 3.0, image: image))
            }
            completion(listProducts)
        }
    }
    
    // Load online image

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


    // Present a alert

    func presentAlert(title: String = "Lỗi", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)

        self.present(alert, animated: true, completion: nil)
    }

    // Init an activity indicator
    func initActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.style = .whiteLarge
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .orange

        return activityIndicator
    }
}




