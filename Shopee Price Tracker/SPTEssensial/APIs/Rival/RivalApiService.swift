//
//  RivalApiService.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/24/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import Alamofire
import NotificationBannerSwift

struct RivalApiService {
    
    private static let sharedNetwork = Network.shared
    
    static func getListRivals(myShopId: String, myProductId: String, completion: @escaping (ConnectionResults, [(Product, Bool)]?) -> Void) {
        // rival, isChosen, numberOfRivals
        
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivals_path + "/\(myShopId)/\(myProductId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 60).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.sharedNetwork.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }
            
            //Successful request
            self.getChosenRivals(shopId: myShopId, productId: myProductId) { (result, chosenRivals) in
                guard result != .failed, let chosenRivals = chosenRivals else {
                    completion(.failed, nil)
                    return
                }
                
                let responseData = response.data
                guard let data = responseData else {
                    completion(.success, [])
                    return
                }
                
                let rivalProducts = try? JSONDecoder.shared.decode([Product].self, from: data)
                
                // convert to tuple (rivalProduct, bool)
                let result = Array(zip(rivalProducts!, chosenRivals).map { rivalProduct, chosenRival in
                    (rivalProduct, chosenRival.0.itemRival?.itemid == rivalProduct.itemid)
                    
                })
                
                completion(.success, result)
            }
        }
    }
    
    static func getListRivalsShops(myShopId: String, myProductId: String, completion: @escaping ([Shop]?) -> Void) {
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivalsShops_path + "/\(myShopId)/\(myProductId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 30).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error!)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion(nil)
                return
            }
            
            let data = response.data!
            
            //Successful request
            let listRivalsShops = try? JSONDecoder.shared.decode([Shop].self, from: data)
            
            completion(listRivalsShops)
        }
    }
    
    
    /// Chọn đối thủ để theo dõi
    /// - Parameter myProductId: id sản phẩm của shop
    /// - Parameter myShopId: id của shop
    /// - Parameter rivalProductId: id sản phẩm của shop đối thủ
    /// - Parameter rivalShopId: id shop của đối thủ
    /// - Parameter autoUpdate: trạng thái theo dõi giá
    /// - Parameter priceDiff: chênh lệch giá
    /// - Parameter min: giá min
    /// - Parameter max: giá max
    /// - Parameter completion: trạng thái kết nối
    static func chooseRival(myProductId: String, myShopId: String, rivalProductId: String, rivalShopId: String, autoUpdate: Bool, priceDiff: Int, from min: Int, to max: Int, completion: @escaping (ConnectionResults) -> Void) {
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rival_path)!
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
                self.sharedNetwork.notifyFailedConnection(error: response.result.error)
                completion(.failed)
                return
            }
            
            //Successful request
            completion(.success)
        }
    }
    
    /// Lấy danh sách sản phẩm đã được chọn để theo dõi giá
    /// - Parameter shopId: id của shop
    /// - Parameter completion: Mảng [kết quả trả về, sản phẩm]
    static func getChosenProducts(shopId: String, completion: @escaping (ConnectionResults, [Product]?) -> Void) {
        // result, product, numberOfChosenRivals, autoUpdate
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.chosenProducts_path + "/\(shopId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.sharedNetwork.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }
            
            //Successful request
            let responseData = response.data!
            
            let selectedProducts = try? JSONDecoder.shared.decode([Product].self, from: responseData)
            completion(.success, selectedProducts)
        }
    }
    
    
    /// Lấy danh sách các đối thủ đã chọn
    /// - Parameter shopId: mã cửa hàng
    /// - Parameter productId: mã sản phẩm - sản phẩm này là sản phẩm mà các đối thủ khác cũng có (ở mức tương tự)
    /// - Parameter completion: Kết quả trả về là một danh sách, một phần tử của danh sách bao gồm (Sản phẩm, cửa hàng, cửa hàng được theo dõi)
    static func getChosenRivals(shopId: String, productId: String, completion: @escaping (ConnectionResults, [(RivalsResponse, Shop)]?) -> Void) {
        // product, shop rivals, numberOfChosenRivals, autoUpdate
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.chosenRivals_path + "/\(shopId)/\(productId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.sharedNetwork.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }
            
            //Successful request
            let responseData = response.data
            
            guard let data = responseData else {
                completion(.success, [])
                return
            }
            
            let response = try? JSONDecoder.shared.decode([RivalsResponse].self, from: data)
            
            var rivalShops: [Shop] = []
            
            response?.forEach { response in
                self.getRivalShop(shopId: response.rival?.rivalShopid, completion: {  (result, rivalShop) in
                    guard result != .failed, let rivalShop = rivalShop else {
                        completion(.failed, nil)
                        return
                    }
                    
                    rivalShops.append(rivalShop)
                })
            }
            
            guard let _response = response else {return}
            let result = Array(zip(_response, rivalShops))
            completion(.success, result)
        }
        
    }
    
    
    /// Lấy danh sách shop đối thủ
    /// - Parameter shopId: id shop
    /// - Parameter completion: kết quả trả về bao gồm trạng thái kết nối + shop đối thủ
    static func getRivalShop(shopId: Int?, completion: @escaping (ConnectionResults, Shop?) -> Void) {
        
        guard let shopId = shopId else {return}
        
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivalsShopInfo_path + "/\(shopId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 60).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.sharedNetwork.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }
            
            //Successful request
            let shop = try? JSONDecoder.shared.decode(Shop.self, from: response.data!)
            
            completion(.success, shop)
        }
    }
}
