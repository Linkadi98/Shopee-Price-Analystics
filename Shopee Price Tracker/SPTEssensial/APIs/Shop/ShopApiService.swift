//
//  ShopApiService.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/26/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct ShopApiService {
    
    let sharedNetwork = Network.shared
    
    // Add shop
    static func addShop(shopId: String, completion: @escaping (ConnectionResults, String?) -> Void) {
        
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.shop_path + "/\(shopId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: nil).responseString { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.sharedNetwork.notifyFailedConnection(error: response.result.error)
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
    static func getListShops(completion: @escaping (ConnectionResults, [Shop]?) -> Void) {
        
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.shop_path)!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.sharedNetwork.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }
            
            //Successful request
            let listShops = try? JSONDecoder.shared.decode([Shop].self, from: response.data!)
            
            self.chooseCurrentShop(listShops: listShops!)
            completion(.success, listShops)
        }
    }
    
    // Choose currentShop
    static func chooseCurrentShop(listShops: [Shop]) {
        let ud = UserDefaults.standard
        if listShops.isEmpty {
            ud.removeObject(forKey: "currentShop")
        } else {
            // Case: didn't save currentShop before, save first shop in list shops
            guard var currentShop = ud.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
                ud.saveObjectInUserDefaults(object: listShops[0] as AnyObject, forKey: "currentShop")
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
                    ud.saveObjectInUserDefaults(object: currentShop as AnyObject, forKey: "currentShop")
                    return
                }
            }
            // savedCurrentShop has been deleted, save first shop in list shops
            ud.saveObjectInUserDefaults(object: listShops[0] as AnyObject, forKey: "currentShop")
            return
        }
    }
}
