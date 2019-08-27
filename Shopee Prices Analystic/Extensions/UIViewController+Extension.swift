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

    func decodeProductJson(value: [String: Any]) -> Product {
        let id = String(value["itemid"] as! Int)
        let shopId = String(value["shopid"] as! Int)
        let name = value["name"] as! String
        let price = Int(value["price"] as! Double)
        let rating = value["rating_star"] as! Double
        let image = (value["images"] as! [String])[0]
        let categoriesData = value["categories"] as! [[String: Any]]
        var categories: [String] = []
        for data in categoriesData {
            categories.append(data["display_name"] as! String)
        }
        let brand = value["brand"] as? String
        let sold = value["historical_sold"] as! Int
        let stock = value["stock"] as! Int
        let discount = value["discount"] as? String
        let maxPrice = Int(value["price_max"] as! Double)
        let minPrice = Int(value["price_min"] as! Double)

        return Product(id: id, shopId: shopId, name: name, price: price, rating: rating, image: image, categories: categories, brand: brand, sold: sold, stock: stock, discount: discount, maxPrice: maxPrice, minPrice: minPrice)
    }

    func decodeShopJson(value: [String: Any]) -> Shop {
        let shopId = String(value["shopid"] as! Int)
        let shopName = value["name"] as! String
        let followersCount = value["follower_count"] as! Int
        let rating = value["rating_star"] as! Double
        let place = value["place"] as! String
        let goodRating = value["rating_good"] as! Int
        let badRating = value["rating_bad"] as! Int
        var image: String?
        if let images = value["images"] as? [String] {
            image = images[0]
        }

        return Shop(shopId: shopId, shopName: shopName, followersCount: followersCount, rating: rating, place: place, goodRating: goodRating, badRating: badRating, image: image)
    }

    func decodeObservationJson(value: [String: Any]) -> Observation {
        let productId = String(value["itemid"] as! Int)
        let shopId = String(value["shopid"] as! Int)
        let rivalShopId = String(value["rivalShopid"] as! Int)
        let rivalProductId = String(value["rivalItemid"] as! Int)
        let autoUpdate = value["auto"] as! Bool
        let priceDiff = value["price"] as! Int
        let minPrice = value["min"] as! Int
        let maxPrice = value["max"] as! Int

        return Observation(productId: productId, shopId: shopId, rivalShopId: rivalShopId, rivalProductId: rivalProductId, autoUpdate: autoUpdate, priceDiff: priceDiff, maxPrice: maxPrice, minPrice: minPrice)
    }

    func getObjectInUserDefaults(forKey key: String) -> AnyObject? {
        if let data = UserDefaults.standard.data(forKey: key) {
            switch key {
            case "currentUser":
                if let currentUser = try? JSONDecoder().decode(User.self, from: data) {
                    return currentUser as AnyObject
                }
            case "currentShop":
                if let currentShop = try? JSONDecoder().decode(Shop.self, from: data) {
                    return currentShop as AnyObject
                }
            default: break
            }
        }
        return nil
    }
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
                let currentUser = User(userName: username, email: email, name: name, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQereh1OeQmTjzhj_oUwdr0gPkv5vcBk1lSv8xGx4e00Eg1ob42", phone: phone)
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

            let currentUser = User(userName: username, email: email, name: name, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQereh1OeQmTjzhj_oUwdr0gPkv5vcBk1lSv8xGx4e00Eg1ob42", phone: phone)
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

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: parameters, timeoutInterval: 120).responseString { (response) in
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
}

// Shop APIs
extension UIViewController {
    // Add shop
    func addShop(shopId: String, completion: @escaping (ConnectionResults, String?) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.shop_path + "/\(shopId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: nil).responseString { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }

            //Successful request
            let responseValue = response.result.value!
            switch responseValue {
            case "Shop đã được thêm":
                completion(.error, "Cửa hàng đã được thêm trước đó")
            case "Shop đã được thêm cho tài khoản khác":
                completion(.error, "Cửa hàng đã được thêm cho tài khoản khác")
            case "Thêm thành công":
                completion(.success, "Thêm cửa hàng thành công")
            default:
                completion(.failed, nil)
                break
            }
        }
    }

    // Get list shop
    func getListShops(completion: @escaping (ConnectionResults, [Shop]?) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.shop_path)!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }

            //Successful request
            var listShops: [Shop] = []
            let responseValue = response.result.value! as! [[String: Any]]
            for value in responseValue {
                listShops.append(self.decodeShopJson(value: value))
            }
            self.chooseCurrentShop(listShops: listShops)
            completion(.success, listShops)
        }
    }

    // Choose currentShop
    func chooseCurrentShop(listShops: [Shop]) {
        if listShops.isEmpty {
            UserDefaults.standard.removeObject(forKey: "currentShop")
        } else {
            // Case: didn't save currentShop before, save first shop in list shops
            guard var currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
                saveObjectInUserDefaults(object: listShops[0] as AnyObject, forKey: "currentShop")
                return
            }

            // Case: save currentShop before
            // Check if listShop contains savedCurrentShop
            // if listShop contains savedCurrentShop, currentShop isn't changed
            if listShops.contains(currentShop) {
                return
            }

            // listShop doesn't contain savedCurrentShop
            for shop in listShops {
                // but maybe shop was changed its properties (not deleted)
                if currentShop.shopId == shop.shopId {
                    currentShop = shop
                    saveObjectInUserDefaults(object: currentShop as AnyObject, forKey: "currentShop")
                    return
                }
            }
            // savedCurrentShop has been deleted, save first shop in list shops
            saveObjectInUserDefaults(object: listShops[0] as AnyObject, forKey: "currentShop")
            return
        }
    }
}

// Product APIs
extension UIViewController {
    // put list products from DB
    func putListProducts(completion: @escaping (ConnectionResults, [Product]?) -> Void) {
        let sharedNetwork = Network.shared
        var url = URL(string: "https://google.com")!
        guard let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            // No products because account doesn't have any shop
            completion(.error, nil)
            return
        }

        url = URL(string: sharedNetwork.base_url + sharedNetwork.items_path + "/\(currentShop.shopId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: nil, timeoutInterval: 30).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }

            //Successful request
            var listProducts: [Product] = []
            let responseValue = response.result.value! as! [[String: Any]]
            for value in responseValue {
                listProducts.append(self.decodeProductJson(value: value))
            }
            completion(.success, listProducts)
        }
    }

    // update price
    func updatePrice(shopId: String, productId: String, newPrice: Int, completion: @escaping (ConnectionResults) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: Network.shared.base_url + Network.shared.price_path + "/\(shopId)/\(productId)/\(newPrice)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed)
                return
            }

            //Successful request
            let responseValue = response.result.value! as! [String: Any]
            if let _ = responseValue["price"] as? Int {
                completion(.success)
            } else {
                completion(.error)
            }
        }
    }
}

// Rival API
extension UIViewController {
    func getListRivals(myShopId: String, myProductId: String, completion: @escaping (ConnectionResults, [(Product, Bool)]?) -> Void) {
        // rival, isChosen
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivals_path + "/\(myShopId)/\(myProductId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 30).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }

            //Successful request
            self.getChosenRivals(shopId: myShopId, productId: myProductId) { (result, chosenRivals) in
                guard result != .failed, let chosenRivals = chosenRivals else {
                    completion(.failed, nil)
                    return
                }

                var listSearchedRivals: [(Product, Bool)] = []
                let responseValue = response.result.value! as! [[String: Any]]
                for value in responseValue {
                    let rival = self.decodeProductJson(value: value)
                    var isChosen = false
                    for chosenRival in chosenRivals {
                        if chosenRival.0.id == rival.id {
                            isChosen = true
                            break
                        }
                    }
                    listSearchedRivals.append((rival, isChosen))
                }

                print("So doi thu: \(listSearchedRivals.count)")
                completion(.success, listSearchedRivals)
            }

        }
    }

    func getListRivalsShops(myShopId: String, myProductId: String, completion: @escaping ([Shop]?) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivalsShops_path + "/\(myShopId)/\(myProductId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 30).responseJSON { (response) in
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
                listRivalsShops.append(self.decodeShopJson(value: value)) // need edited
                print("So shop doi thu: \(listRivalsShops.count)")
            }
            completion(listRivalsShops)
        }
    }

    // choose rival
    func chooseRival(myProductId: String, myShopId: String, rivalProductId: String, rivalShopId: String, autoUpdate: Bool, priceDiff: Int, from min: Int, to max: Int, completion: @escaping (ConnectionResults) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: Network.shared.base_url + Network.shared.rivalChoice_path)!
        let parameters: Parameters = [
            "itemid": myProductId,
            "shopid": myShopId,
            "rivalShopid": rivalShopId,
            "rivalItemid": rivalProductId,
            "auto": autoUpdate,
            "price": priceDiff,
            "max": max,
            "min": min
        ]

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: parameters).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed)
                return
            }

            //Successful request
            completion(.success)
        }
    }

    // Get chosen products
    func getChosenProducts(shopId: String, completion: @escaping (ConnectionResults, [(Product, Int, Bool)]?) -> Void) {
        // result, product, numberOfChosenRivals, autoUpdate
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.chosenProducts_path + "/\(shopId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }

            //Successful request
            var chosenProducts: [(Product, Int, Bool)] = []
            let responseValue = response.result.value! as! [[String: Any]]
            for value in responseValue {
                let product = self.decodeProductJson(value: value)

                let numberOfChosenRivals = value["chosen"] as! Int
                let autoUpdate = value["auto"] as! Bool

                chosenProducts.append((product, numberOfChosenRivals, autoUpdate))
            }
            completion(.success, chosenProducts)
        }
    }

    // Get chosen rivals
    func getChosenRivals(shopId: String, productId: String, completion: @escaping (ConnectionResults, [(Product, Shop, Observation)]?) -> Void) {
        // product, shop rivals, numberOfChosenRivals, autoUpdate
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.chosenRivals_path + "/\(shopId)/\(productId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }

            //Successful request
            var chosenRivals: [(Product, Shop, Observation)] = []
            let responseValue = response.result.value! as! [[String: Any]]
            let count = responseValue.count
            var i = 0
            for value in responseValue {
                let rival = self.decodeProductJson(value: value["itemRival"] as! [String: Any])
                let observation = self.decodeObservationJson(value: value["rival"] as! [String: Any])

                self.getRivalsShop(shopId: observation.rivalShopId) { (result, rivalsShop) in
                    guard result != .failed, let rivalsShop = rivalsShop else {
                        completion(.failed, nil)
                        return
                    }

                    chosenRivals.append((rival, rivalsShop, observation))
                    i += 1
                    if i == count {
                        completion(.success, chosenRivals)
                    }
                }
            }
        }
    }

    // Get rivals' shops info
    func getRivalsShop(shopId: String, completion: @escaping (ConnectionResults, Shop?) -> Void) {
        // shop rivals, product, numberOfChosenRivals, autoUpdate
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivalsShopInfo_path + "/\(shopId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }

            //Successful request
            let responseValue = response.result.value! as! [String: Any]
            completion(.success, self.decodeShopJson(value: responseValue))
        }
    }
}

// Price Observation
extension UIViewController {
    func priceObservations(productId: String, completion: @escaping (ConnectionResults, [(Int, String, String)]?) -> Void) {
        // result, price, date, time
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.priceObservation_path + "/\(productId)")!

        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }

            //Successful request
            var priceObservations: [(Int, String, String)] = []
            let responseValue = response.result.value! as! [[String: Any]]
            for value in responseValue {
                let timeValue = value["date"] as! String
                let date = String(timeValue.prefix(10))
                let time = String(String(timeValue.dropFirst(11)).prefix(8))
                let price = Int(value["price"] as! Double)
                priceObservations.append((price, date, time))
            }
            completion(.success, priceObservations)
        }

    }
}





