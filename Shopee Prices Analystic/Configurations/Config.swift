//
//  Config.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 8/5/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import Alamofire

class Config {
    static let BASE_URL = "http://192.168.10.124:8081"
    static let LOGIN_PATH = "/login"
    static let REGISTER_PATH = "/register"
    static var HEADERS: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
}
