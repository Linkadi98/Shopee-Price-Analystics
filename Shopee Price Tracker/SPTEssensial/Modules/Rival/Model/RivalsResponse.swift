//
//  RivalsResponse.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/26/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct RivalsResponse: Codable {
    let item: Product?
    let rival: Rival?
    let itemRival: Product?
}

// MARK: - Rival
struct Rival: Codable {
    let itemid, shopid, rivalShopid, rivalItemid: Int?
    let auto: Bool?
    let price, max, min: Double?
}
