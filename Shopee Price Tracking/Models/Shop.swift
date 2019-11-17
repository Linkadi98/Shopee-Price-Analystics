//
//  Shop.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct Shop: Codable, Equatable {
    var shopId: String
    var shopName: String
    var followersCount: Int
    var rating: Double
    var place: String
    var goodRating: Int
    var badRating: Int
    var image: String?

//    public static func == (shop1: Shop, shop2: Shop) -> Bool {
//        return
//            shop1.shopId == shop2.shopId &&
//            shop1.shopName == shop2.shopName
//    }
}

