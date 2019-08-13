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
//    let base_url = "http://192.168.1.5:8081"
    let base_url = "http://192.168.1.38:8081"
    let login_path = "/login"
    let register_path = "/register"
    let shop_path = "/shop"
    let items_path = "/items"
    let price_path = "/item/price"
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

