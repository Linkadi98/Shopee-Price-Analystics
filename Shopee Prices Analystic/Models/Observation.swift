//
//  Observation.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 8/26/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct Observation {
    let productId: String
    let shopId: String
    let rivalShopId: String
    let rivalProductId: String
    let autoUpdate: Bool
    let priceDiff: Int
    let maxPrice: Int
    let minPrice: Int
}
