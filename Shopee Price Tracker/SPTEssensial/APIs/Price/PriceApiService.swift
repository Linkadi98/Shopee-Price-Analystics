//
//  PriceApiService.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/26/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import Alamofire


struct PriceApiService {
    
    private static let sharedNetwork = Network.shared
    
    static func priceObservations(productId: String, completion: @escaping (ConnectionResults, [String]?, [Int]?) -> Void) {
        // result, date, price
        
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.priceObservation_path + "/\(productId)")!
        
        print(url)
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 30).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                //                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, [], [])
                return
            }
            
            //Successful request
            var dates: [String] = []
            var prices: [Int] = []
            guard let responseValue = response.result.value as? [[String: Any]] else {
                completion(.success, [], [])
                return
            }
            for value in responseValue {
                var dateString = String((value["date"] as! String).prefix(13))
                let price = Int(value["price"] as! Double)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
                let date = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = "dd-MM HH'h'mm"
                dateString = dateFormatter.string(from: date!)
                dates.append(dateString)
                prices.append(price)
            }
            completion(.success, dates, prices)
        }
    }
    
    static func getStatistics(product: Product, completion: @escaping (ConnectionResults, [Int]?, Int?) -> Void) {
        // counts, average
        
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.statistics_path + "/\(String(describing: product.shopid))/\(String(describing: product.itemid))")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 30).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.sharedNetwork.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil, nil)
                return
            }
            
            //Successful request
            var counts: [Int] = []
            let responseValue = response.result.value! as! [String: Any]
            let statistics = responseValue["ranks"] as! [[String: Any]]
            let averagePrice = Int(responseValue["medium"] as! Double)
            for statistic in statistics {
                counts.append(statistic["count"] as! Int)
            }
            
            completion(.success, counts, averagePrice)
        }
    }
    
    // delete 1 rival
    static func deleteRival(myProductId: String, myShopId: String, rivalProductId: String, rivalShopId: String, completion: @escaping (ConnectionResults) -> Void) {
        
        let url = URL(string: Network.shared.base_url + Network.shared.rival_path)!
        let parameters: Parameters = [
            "itemid": myProductId,
            "shopid": myShopId,
            "rivalShopid": rivalShopId,
            "rivalItemid": rivalProductId
        ]
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .delete, parameters: parameters).responseJSON { (response) in
            // Failed request
            //            guard response.result.isSuccess else {
            //                self.notifyFailedConnection(error: response.result.error)
            //                completion(.failed)
            //                return
            //            }
            
            
            //Successful request
            //            guard let responseValue = response.result.value as? [String: Any], let _ = responseValue["itemid"] else {
            //                completion(.error)
            //                return
            //            }
            
            completion(.success)
        }
    }
    
    // delete 1 rival
    static func deleteRivals(productId: String, completion: @escaping (ConnectionResults) -> Void) {
        
        let url = URL(string: Network.shared.base_url + Network.shared.rival_path + "/\(productId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .delete, parameters: nil).responseJSON { (response) in
            completion(.success)
        }
    }
    
    static func getAutoUpdateHistory(product: Product, completion: @escaping (ConnectionResults, [AutoUpdateHistory]?) -> Void) {
        // counts
        
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.autoUpdate_path + "/\(String(describing: product.itemid))")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 30).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.sharedNetwork.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }
            
            //Successful request
            var autoUpdateHistory: [AutoUpdateHistory] = []
            let responseValue = response.result.value as! [[String: Any]]
            for value in responseValue {
                var dateString = String((value["date"] as! String).prefix(13))
                let newPrice = Int(value["price"] as! Double)
                let oldPrice = Int(value["oldPrice"] as! Double)
                let rivalShopName = value["shopRival"] as! String
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
                let date = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = "dd-MM HH'h'mm"
                dateString = dateFormatter.string(from: date!)
                
                autoUpdateHistory.append(AutoUpdateHistory(date: dateString, rivalShopName: rivalShopName, oldPrice: oldPrice, newPrice: newPrice))
            }
            completion(.success, autoUpdateHistory)
        }
    }
}
