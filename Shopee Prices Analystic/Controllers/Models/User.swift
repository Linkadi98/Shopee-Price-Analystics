//
//  User.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/16/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct User {
    var name: String?
    var image: String?
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
