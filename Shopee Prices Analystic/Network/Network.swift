//
//  Config.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 8/5/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import Alamofire

class Network {
    static let shared = Network()
//    let base_url = "http://192.168.1.39:8081"

    let base_url = "http://172.104.173.222:8081"
    let login_path = "/login"
    let register_path = "/register"
    let forget_path = "/forget"
    let info_path = "/infor"
    let updateInfo_path = "/updateInfor"
    let shop_path = "/shop" // add shop + get shops from DB
    let items_path = "/getItems" // update items from shopee + get items from DB
    let item_path = "/item" // get item from DB
    let price_path = "/updatePrice" // change price
    let rival_path = "/rival" // choose rival, delete rival(s)
    let chosenRivals_path = "/rivals" // chosen rivals
    let rivalsShopInfo_path = "/shopInfor" // get rivals shop info
    let rivals_path = "/getRivals" // get rivals
    let rivalsShops_path = "/shopRival" // get rivals' shops
    let chosenProducts_path = "/chosenItems" // get chosen products
    let priceObservation_path = "/itemPrice" // get price observation of a rival
    let statistics_path = "/statistical" // get price observation of a rival

    var headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]

    func alamofireDataRequest(url: URL, httpMethod: HTTPMethod, parameters: Parameters?,timeoutInterval: TimeInterval = 15) -> DataRequest {
        // Configure request
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        for (key, value) in self.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        if let parameters = parameters {
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        request.timeoutInterval = timeoutInterval
        // Request
        return Alamofire.request(request as URLRequestConvertible)
    }

    // Default timeoutInterval is 15 seconds, except:
    // Forget account (120 seconds)
    // Put list shops (30)
    // Get rivals (30)
    // Get rivals' shops (30)
}

enum ConnectionResults {
    case failed
    case error
    case success
}

