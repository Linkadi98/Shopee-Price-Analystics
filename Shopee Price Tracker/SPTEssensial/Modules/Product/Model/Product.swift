//
//  Product.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/17/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct Product: Codable {
    
    let id: String?
    let shopId: String?
    var name: String?
    var price: Int?
    var rating: Double?
    var image: String?
    var categories: [String]?
    var brand: String?
    var sold: Int? // historical_sold
    var stock: Int?
    var discount: String?
    var maxPrice: Int?
    var minPrice: Int?
    
    var inventory: Int?
    var ratingArray: [Int]?
    var soldPrice: String?

}
