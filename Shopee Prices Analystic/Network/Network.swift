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
//    let base_url = "http://192.168.1.3:8081"

    let base_url = "https://c12513be.ngrok.io"
    let login_path = "/login"
    let register_path = "/register"
    let forget_path = "/forget"
    let info_path = "/infor"
    let updateInfo_path = "/updateInfor"
    let shop_path = "/shop" // add shop + get shops from DB
    let items_path = "/getItems" // update items from shopee + get items from DB
    let item_path = "/item" // get item from DB
    let price_path = "/updatePrice" // change price
    let rivals_path = "/getRivals" // get rivals
    let rivalsShops_path = "/shopRival" // get rivals' shop
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
}

