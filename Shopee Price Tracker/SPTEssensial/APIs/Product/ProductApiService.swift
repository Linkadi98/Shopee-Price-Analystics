//
//  ProductApiService.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/17/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire

enum ProductApiService {
    case putListProduct
    case updateProductPrice
}


extension ProductApiService {
    
    static func getListProducts(completion: @escaping (ConnectionResults, [Product]?) -> Void) {
        let sharedNetwork = Network.shared
        let ud = UserDefaults.standard
        var url = URL(string: "https://google.com")!
        guard let currentShop = ud.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            // No products because account doesn't have any shop
            completion(.error, nil)
            return
        }
        
        url = URL(string: sharedNetwork.base_url + sharedNetwork.items_path + "/\(currentShop.shopid!)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: nil, timeoutInterval: 10).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess, (response.data != nil) else {
                sharedNetwork.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }
            
            //Successful request
            let data = response.data!
            let productsResponse = try? JSONDecoder.shared.decode([Product].self, from: data)
            
            
//            let responseValue = response.result.value! as! [[String: Any]]
//            for value in responseValue {
//                listProducts.append(self.decodeProductJson(value: value))
//            }
            completion(.success, productsResponse)
        }
    }
    
    // update price
//    static func updatePrice(shopId: Int, productId: Int, newPrice: Int, completion: @escaping (ConnectionResults) -> Void) {
//        let sharedNetwork = Network.shared
//        let url = URL(string: Network.shared.base_url + Network.shared.price_path + "/\(shopId)/\(productId)/\(newPrice)")!
//
//        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .put, parameters: nil).responseJSON { (response) in
//            // Failed request
//            guard response.result.isSuccess else {
//                //                self.notifyFailedConnection(error: response.result.error)
//                completion(.failed)
//                return
//            }
//
//            //Successful request
//            let responseValue = response.result.value! as! [String: Any]
//            if let _ = responseValue["price"] as? Int {
//                completion(.success)
//            } else {
//                completion(.error)
//            }
//        }
//    }

    static func updatePrice(shopId: Int, productId: Int, newPrice: Int, completion: @escaping (ConnectionResults) -> Void) {
        let url = URL(string: "http://202.191.56.159:2671/update?shopId=\(shopId)&id=\(productId)&price=\(newPrice)")!

        let headers = [
            "Content-Type": "application/json"
        ]

        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard response.result.isSuccess else {
                //                self.notifyFailedConnection(error: response.result.error)
                completion(.failed)
                return
            }

            //Successful request
            let responseValue = response.result.value as! [String: String]
            print(responseValue)
            if responseValue["ok"] == "OK" {
                completion(.success)
            } else {
                completion(.error)
            }
        }
    }
}
