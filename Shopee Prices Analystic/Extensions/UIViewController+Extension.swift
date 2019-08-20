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
            let email = fbDictionary["email"] as! String

            print(id)
            let currentUser = User(name: name, image: "https://graph.facebook.com/\(id)/picture?type=large", email: email, phone: nil)

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
        let email = user.profile.email

        // Google cover picture
        var pic = ""
        if user.profile.hasImage
        {
            pic = user.profile.imageURL(withDimension: 150)!.absoluteString
        }

        let currentUser = User(name: fullName!, image: pic, email: email, phone: nil)

        if let encoded = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }

    func getInfo(username: String, completion: @escaping () -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.info_path)!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).validate().responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion()
                return
            }

            //Successful request
            let responseValue = response.result.value! as! [String: Any]
            let phone = responseValue["phone"] as? String
            if let email = responseValue["email"] as? String {
                // Lưu currentUser trong UserDefaults
                let currentUser = User(name: username, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQereh1OeQmTjzhj_oUwdr0gPkv5vcBk1lSv8xGx4e00Eg1ob42", email: email, phone: phone) // NEED EDITED
                if let encoded = try? JSONEncoder().encode(currentUser) {
                    UserDefaults.standard.set(encoded, forKey: "currentUser")
                }
            }
            completion()
        }
    }

    func updateInfo(phone: String, password: String, completion: @escaping (String) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.updateInfo_path)!
        var parameters: Parameters = [
            "phone": phone,
            "password": password
        ]
        if phone == "" {
            parameters["phone"] = nil
        }

        if password == "" {
            parameters["password"] = nil
        }

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: parameters).validate().responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion("failed")
                return
            }

            //Successful request
            completion("success")
        }
    }

    func checkAccount(username: String, password: String, completion: @escaping (String) -> Void) {
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
                    completion("failed")
                    return
                }

                //Successful request
                let responseValue = response.result.value! as! [String: Any]
                guard let _ = responseValue["token"] as? String else {
                    self.presentAlert(message: "Sai tài khoản hoặc mật khẩu")
                    completion("wrong")
                    return
                }
                
                completion("success")
            }
        }
    }

    // Get list shop
    func getListShops(completion: @escaping ([Shop]?) -> Void) {
        let sharedNetwork = Network.shared
        // let url = URL(string: "http://192.168.10.8:3000" + sharedNetwork.shop_path)!
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.shop_path)!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).validate().responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion(nil)
                return
            }

            //Successful request
            var listShops: [Shop] = []
//            print(response.result.value)
            let responseValue = response.result.value! as! [[String: Any]]
            print(responseValue)
            for value in responseValue {
                let shopId = String(value["shopid"] as! Int64)
                let shopName = value["name"] as! String
                let followersCount = value["follower_count"] as! Int64
                let rating = value["rating_star"] as! Double
                listShops.append(Shop(shopId: shopId, shopName: shopName, followersCount: followersCount, rating: rating))
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

    // Add shop
    func addShop(shopId: String, completion: @escaping (String) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.shop_path + "/\(shopId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: nil).validate().responseJSON { (response) in
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

    // Change currentShop
    func changeCurrentShop(newShop: Shop) {
        if let encoded = try? JSONEncoder().encode(newShop) {
            UserDefaults.standard.set(encoded, forKey: "currentShop")
        }
        print("Changrsjsj: \(newShop)")
    }

    // put list products from DB
    func putListProducts(completion: @escaping ([Product]?) -> Void) {
        let sharedNetwork = Network.shared
        //        let url = URL(string: "http://192.168.10.8:3000" + sharedNetwork.shop_path)!
        var url = URL(string: "https://google.com")!
        if let currentShopData = UserDefaults.standard.data(forKey: "currentShop") {
            if let currentShop = try? JSONDecoder().decode(Shop.self, from: currentShopData) {
                url = URL(string: sharedNetwork.base_url + sharedNetwork.items_path + "/\(currentShop.shopId)")!
                print("6969: \(currentShop.shopId)")
            }
        } else {
            print("Chua co san pham vi chua ket noi cua hang")
            completion([])
            return
        }

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: nil).validate().responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion(nil)
                return
            }

            //Successful request
            var listProducts: [Product] = []
            let responseValue = response.result.value! as! [[String: Any]]
            for value in responseValue {
                let id = String(value["itemid"] as! Int)
                let shopId = String(value["shopid"] as! Int)
                let name = value["name"] as! String
                let price = Int(value["price"] as! Double)
                let image = (value["images"] as! [String])[0]
                listProducts.append(Product(id: id, shopId: shopId, name: name, price: price, rating: 3.0, image: image))
                print("So san pham: \(listProducts.count)")
            }
            completion(listProducts)
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
                print("6969: \(currentShop.shopId)")
            }
        } else {
            print("Chua co san pham vi chua ket noi cua hang")
            completion([])
            return
        }

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).validate().responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion(nil)
                return
            }

            //Successful request
            var listProducts: [Product] = []
            let responseValue = response.result.value! as! [[String: Any]]
            for value in responseValue {
                let id = String(value["itemid"] as! Int)
                let shopId = String(value["shopid"] as! Int)
                let name = value["name"] as! String
                let price = Int(value["price"] as! Double)
                let image = (value["images"] as! [String])[0]
                listProducts.append(Product(id: id, shopId: shopId, name: name, price: price, rating: 3.0, image: image))
                print("So san pham: \(listProducts.count)")
            }
            completion(listProducts)
        }
    }

    func getListRivals(myShopId: String, myProductId: String, completion: @escaping ([Product]?) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivals_path + "/\(myShopId)/\(myProductId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 30).validate().responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion(nil)
                return
            }

            //Successful request
            var listRivals: [Product] = []
            let responseValue = response.result.value! as! [[String: Any]]
            for value in responseValue {
                let id = String(value["itemid"] as! Int)
                let shopId = String(value["shopid"] as! Int)
                let name = value["name"] as! String
                let price = Int(value["price"] as! Double)
                let image = (value["images"] as! [String])[0]
                listRivals.append(Product(id: id, shopId: shopId, name: name, price: price, rating: 3.0, image: image))
                print("So doi thu: \(listRivals.count)")
            }
            completion(listRivals)
        }
    }

    func getListRivalsShops(myShopId: String, myProductId: String, completion: @escaping ([Shop]?) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivalsShops_path + "/\(myShopId)/\(myProductId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 30).validate().responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion(nil)
                return
            }

            //Successful request
            var listRivalsShops: [Shop] = []
            let responseValue = response.result.value! as! [[String: Any]]
            for value in responseValue {
                let shopId = String(value["shopid"] as! Int64)
                let shopName = value["name"] as! String
                let followersCount = value["follower_count"] as! Int64
                let rating = value["rating_star"] as! Double
                listRivalsShops.append(Shop(shopId: shopId, shopName: shopName, followersCount: followersCount, rating: rating))
                print("So shop doi thu: \(listRivalsShops.count)")
            }
            completion(listRivalsShops)
        }
    }

    // update price
    func updatePrice(shopId: String, productId: String, newPrice: Int, completion: @escaping (String) -> Void) {
        let sharedNetwork = Network.shared
        //        let url = URL(string: "http://192.168.10.8:3000" + sharedNetwork.shop_path)!
        let url = URL(string: Network.shared.base_url + Network.shared.price_path + "/\(shopId)/\(productId)/\(newPrice)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: nil).validate().responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion("failed")
                return
            }

            //Successful request
            let responseValue = response.result.value! as! [String: Any]
            print(responseValue)
            if let _ = responseValue["price"] as? Int {
//                StatusBarNotificationBanner(title: "Sửa giá thành công", style: .success).show()
                completion("success")
            } else {
//                self.presentAlert(message: "Sửa giá thất bại, vui lòng thử lại sau")
                completion("error")
            }
        }
    }

    // choose rival
    func chooseRival(myProductId: String, myShopId: String, rivalProductId: String, rivalShopId: String, completion: @escaping (String) -> Void) {
        let sharedNetwork = Network.shared
        //        let url = URL(string: "http://192.168.10.8:3000" + sharedNetwork.shop_path)!
        let url = URL(string: Network.shared.base_url + Network.shared.rivalChoice_path)!
        let parameters: Parameters = [
            "itemid": myProductId,
            "shopid": myShopId,
            "opponent": rivalShopId,
            "rival": rivalProductId
        ]

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: parameters).validate().responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion("failed")
                return
            }

            //Successful request
            let responseValue = response.result.value! as! [String: Any]
            print(responseValue)
            completion("success")
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
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
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




