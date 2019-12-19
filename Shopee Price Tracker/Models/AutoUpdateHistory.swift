//
//  AutoUpdateHistory.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 8/28/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct AutoUpdateHistory: Codable {
    let date: String?
    let shopRival: String?
    let oldPrice: Int?
    let price: Int?
}
