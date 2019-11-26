//
//  RivalShop.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/26/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct RivalShopInfo: Codable {
    let shopid: Int?
    let name: String?
    let images: [String]?
    let place: String?
    let ratingGood, ratingBad, ratingNormal, followerCount: Int?
    let ratingStar: Double?
    let ratingCount: [Int]?
    let itemid: Int?
}
