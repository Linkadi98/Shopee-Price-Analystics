//
//  Product.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/17/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct Product: Codable {
    let itemid: Int?
    let images: [String]?
    let name: String?
    let shopid: Int?
    let brand: String?
    let price, ratingStar: Int?
    let ratingCount: [Int]?
    let historicalSold, sold, priceMax, priceMin: Int?
    let discount: Int?
    let stock: Int?
    let categories: [Category]?
    let itemPrice: ItemPrice?
    let chosen: Int?
    let auto: Bool?
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let displayName: String?
    let catid: Int?
}

// MARK: - Item price

struct ItemPrice: Codable {
    let id: Int?
    let date: String?
    let time: String?
    let price: Double?
}



