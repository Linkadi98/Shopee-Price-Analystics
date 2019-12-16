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
import AlamofireImage

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
            let currentUser = User(userName: nil, email: email, name: name, image: "https://graph.facebook.com/\(id)/picture?type=large", phone: nil)

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

        let currentUser = User(userName: nil, email: email!, name: fullName!, image: pic, phone: nil)

        if let encoded = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }

//    func checkAccount(username: String, password: String, completion: @escaping (String) -> Void) {
//        let sharedNetwork = Network.shared
//        let url = URL(string: sharedNetwork.base_url + sharedNetwork.login_path)!
//        let parameters: Parameters = [
//            "username" : username,
//            "password" : password
//        ]
//
//        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: parameters).validate().responseJSON { (response) in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                // Failed request
//                guard response.result.isSuccess else {
//                    print("Error when fetching data: \(response.result.error)")
//                    StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
//                    completion("failed")
//                    return
//                }
//
//                //Successful request
//                let responseValue = response.result.value! as! [String: Any]
//                guard let _ = responseValue["token"] as? String else {
//                    self.presentAlert(message: "Sai tài khoản hoặc mật khẩu")
//                    completion("wrong")
//                    return
//                }
//
//                completion("success")
//            }
//        }
//    }

//    // get list products from DB
//    func getListProducts(completion: @escaping ([Product]?) -> Void) {
//        let sharedNetwork = Network.shared
//        //        let url = URL(string: "http://192.168.10.8:3000" + sharedNetwork.shop_path)!
//        var url = URL(string: "https://google.com")!
//        if let currentShopData = UserDefaults.standard.data(forKey: "currentShop") {
//            if let currentShop = try? JSONDecoder().decode(Shop.self, from: currentShopData) {
//                url = URL(string: sharedNetwork.base_url + sharedNetwork.items_path + "/\(currentShop.shopId)")!
//                print("Đang lấy sản phẩm của shop: \(currentShop.shopName) \(currentShop.shopId)")
//            }
//        } else {
//            print("Chua co san pham vi chua ket noi cua hang")
//            completion([])
//            return
//        }
//
//        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).validate().responseJSON { (response) in
//            // Failed request
//            guard response.result.isSuccess else {
//                print("Error when fetching data: \(response.result.error)")
//                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
//                completion(nil)
//                return
//            }
//
//            //Successful request
//            var listProducts: [Product] = []
//            let responseValue = response.result.value! as! [[String: Any]]
//            for value in responseValue {
//                let id = String(value["itemid"] as! Int)
//                let shopId = String(value["shopid"] as! Int)
//                let name = value["name"] as! String
//                let price = Int(value["price"] as! Double)
//                let image = (value["images"] as! [String])[0]
//                listProducts.append(Product(id: id, shopId: shopId, name: name, price: price, rating: 3.0, image: image))
//            }
//            completion(listProducts)
//        }
//    }
    
    // Load online image
    


    // Present a alert

    func presentAlert(title: String = "Lỗi", message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: handler)
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

    func startLoading() -> UIActivityIndicatorView {
        UIApplication.shared.beginIgnoringInteractionEvents()

        let activityIndicator = self.initActivityIndicator()
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return activityIndicator
    }

    func endLoading(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}


// Network activities
extension UIViewController {
    // Check if connection was failed
    func notifyFailedConnection(error: Error?) {
        // Show errors
        if let error = error {
            print("Error when fetching data: \(error).")
        } else {
            print("Unknown error when fetching data.")
        }
        
        // Notify users
        StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
    }

    func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(Date(timeIntervalSinceNow: 21600), forKey: "expiredTimeOfToken")
        Network.shared.headers["Authorization"] = token
    }

    func saveObjectInUserDefaults(object: AnyObject, forKey key: String) {
        switch key {
        case "currentUser":
            if let currentUser = object as? User {
                if let encoded = try? JSONEncoder().encode(currentUser) {
                    UserDefaults.standard.set(encoded, forKey: "currentUser")
                }
            } else {
                print("Object didn't match key")
            }
        case "currentShop":
            if let currentShop = object as? Shop {
                if let encoded = try? JSONEncoder().encode(currentShop) {
                    UserDefaults.standard.set(encoded, forKey: "currentShop")
                }
            } else {
                print("Object didn't match key")
            }
        default: break
        }
    }

//    func decodeProductJson(value: [String: Any]) -> Product {
//        let id = String(value["itemid"] as! Int)
//        let shopId = String(value["shopid"] as! Int)
//        let name = value["name"] as! String
//        let price = Int(value["price"] as! Double)
//        let rating = value["rating_star"] as! Double
//        let image = (value["images"] as! [String])[0]
//        let categoriesData = value["categories"] as! [[String: Any]]
//        var categories: [String] = []
//        for data in categoriesData {
//            categories.append(data["display_name"] as! String)
//        }
//        let brand = value["brand"] as? String
//        let sold = value["historical_sold"] as! Int
//        let stock = value["stock"] as! Int
//        let discount = value["discount"] as? String
//        let maxPrice = Int(value["price_max"] as! Double)
//        let minPrice = Int(value["price_min"] as! Double)
//
//        return Product(id: id, shopId: shopId, name: name, price: price, rating: rating, image: image, categories: categories, brand: brand, sold: sold, stock: stock, discount: discount, maxPrice: maxPrice, minPrice: minPrice)
//    }
//
//    func decodeShopJson(value: [String: Any]) -> Shop {
//        let shopId = String(value["shopid"] as! Int)
//        let shopName = value["name"] as! String
//        let followersCount = value["follower_count"] as! Int
//        let rating = value["rating_star"] as! Double
//        let place = value["place"] as! String
//        let goodRating = value["rating_good"] as! Int
//        let badRating = value["rating_bad"] as! Int
//        var image: String?
//        if let images = value["images"] as? [String] {
//            image = images[0]
//        }
//
//        return Shop(shopId: shopId, shopName: shopName, followersCount: followersCount, rating: rating, place: place, goodRating: goodRating, badRating: badRating, image: image)
//    }
//
//    func decodeObservationJson(value: [String: Any]) -> Observation {
//        let productId = String(value["itemid"] as! Int)
//        let shopId = String(value["shopid"] as! Int)
//        let rivalShopId = String(value["rivalShopid"] as! Int)
//        let rivalProductId = String(value["rivalItemid"] as! Int)
//        let autoUpdate = value["auto"] as! Bool
//        let priceDiff = value["price"] as! Int
//        let minPrice = value["min"] as! Int
//        let maxPrice = value["max"] as! Int
//
//        return Observation(productId: productId, shopId: shopId, rivalShopId: rivalShopId, rivalProductId: rivalProductId, autoUpdate: autoUpdate, priceDiff: priceDiff, maxPrice: maxPrice, minPrice: minPrice)
//    }

//    func getObjectInUserDefaults(forKey key: String) -> AnyObject? {
//        if let data = UserDefaults.standard.data(forKey: key) {
//            switch key {
//            case "currentUser":
//                if let currentUser = try? JSONDecoder().decode(User.self, from: data) {
//                    return currentUser as AnyObject
//                }
//            case "currentShop":
//                if let currentShop = try? JSONDecoder().decode(Shop.self, from: data) {
//                    return currentShop as AnyObject
//                }
//            default: break
//            }
//        }
//        return nil
//    }
}

// User APIs
extension UIViewController {
    func register(name: String, phone: String?, email: String, username: String, password: String, completion: @escaping (ConnectionResults) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.register_path)!
        var parameters: Parameters = [
            "username" : username,
            "password" : password,
            "email": email,
            "name": name
        ]
        if let phone = phone {
            parameters["phone"] = phone
        }

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: parameters).responseJSON { (response) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Failed request
                guard response.result.isSuccess else {
                    self.notifyFailedConnection(error: response.result.error)
                    completion(.failed)
                    return
                }

                // Successful request
                let responseValue = response.result.value! as! [String: Any]
                guard let token = responseValue["token"] as? String else {
                    completion(.error)
                    return
                }

                // Save token
                print(token)
                let currentUser = User(userName: username, email: email, name: name, image: "https://ui-avatars.com/api/?name=\(name)", phone: phone)
                self.saveToken(token: token)
                self.saveObjectInUserDefaults(object: currentUser as AnyObject, forKey: "currentUser")
                
                completion(.success)
            }
        }
    }

    func login(username: String, password: String, completion: @escaping (ConnectionResults) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.login_path)!
        let parameters: Parameters = [
            "username" : username,
            "password" : password
        ]

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: parameters).responseJSON { (response) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Failed request
                guard response.result.isSuccess else {
                    self.notifyFailedConnection(error: response.result.error)
                    completion(.failed)
                    return
                }

                //Successful request
                let responseValue = response.result.value! as! [String: Any]
                guard let token = responseValue["token"] as? String else {
                    completion(.error)
                    return
                }

                // Save token and its expired time
                print(token)
                self.saveToken(token: token)

                self.getInfo(username: username) { result in
                    switch result {
                    case .success:
                        completion(.success)
                    default:
                        completion(.failed)
                        return
                    }
                }
            }
        }
    }

    func getInfo(username: String, completion: @escaping (ConnectionResults) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.info_path)!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed)
                return
            }

            //Successful request
            let responseValue = response.result.value! as! [String: Any]
            let phone = responseValue["phone"] as? String
            let email = responseValue["email"] as! String
            var name = ""
            if let nameValue = responseValue["name"] as? String {
                name = nameValue
            } else {
                name = "Unknown"
            }

            let currentUser = User(userName: username, email: email, name: name, image: "https://ui-avatars.com/api/?name=\(name)", phone: phone)
            self.saveObjectInUserDefaults(object: currentUser as AnyObject, forKey: "currentUser")

            completion(.success)
        }
    }

    func forget(email: String, completion: @escaping (ConnectionResults) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.forget_path)!
        let parameters: Parameters = [
            "email" : email
        ]

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: parameters, timeoutInterval: 10).responseString { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed)
                return
            }

            //Successful request
            let responseValue = response.result.value!
            switch responseValue {
            case "mail lỗi":
                completion(.error)
            case "Đề nghị check mail":
                completion(.success)
            default:
                completion(.failed)
                break
            }
        }
    }

    func updateInfo(currentPassword: String?, newPassword: String?, name: String?, phone: String?, completion: @escaping (ConnectionResults) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.updateInfo_path)!
        var parameters: Parameters = [:]

        parameters["passwordConfirm"] = currentPassword
        parameters["password"] = newPassword
        parameters["name"] = name
        parameters["phone"] = phone

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: parameters).responseString { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed)
                return
            }

            //Successful request
            let responseValue = response.result.value!
            switch responseValue {
            case "update không thành công":
                completion(.error)
            case "update thành công":
                completion(.success)
            default:
                completion(.failed)
                break
            }
        }
    }

    func loadOnlineImageByAlamofire(withName name: String, to imageView: UIImageView) {
        guard let url = URL(string: "https://ui-avatars.com/api/?size=100&background=ffae00&color=ffffff&name=\(name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)") else {
            return
        }

        Alamofire.request(url).responseImage { (response) in
            if let image = response.result.value {
                imageView.image = image
            }
        }
    }
}






