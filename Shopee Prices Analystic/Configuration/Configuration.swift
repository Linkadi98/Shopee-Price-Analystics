//
//  Convention.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 7/26/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import Alamofire

class Configuration {
    static let BASE_URL = "http://192.168.36.28:8081"
    static let REGISTER_PATH = "/register"
    static let LOGIN_PATH = "/login"
    static var HEADERS: HTTPHeaders = [
        "Content-type": "application/json",
        "Accept": "application/json"
    ]

    // Save token in UserDefaults
}
