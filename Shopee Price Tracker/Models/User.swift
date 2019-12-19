//
//  User.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/16/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct User: Codable {
    let userName: String?
    let email: String
    var name: String
    var image: String
    var phone: String?
}
