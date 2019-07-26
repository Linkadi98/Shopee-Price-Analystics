//
//  Convention.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 7/26/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

class Convention {
    let baseUrlString = "http://192.168.36.28:8081"
    let registerPathString = "/register"
    let loginPathString = "/login"
    let headers = [
        "Content-type": "application/json",
        "Accept": "application/json"
    ]

    func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token")
    }
}
