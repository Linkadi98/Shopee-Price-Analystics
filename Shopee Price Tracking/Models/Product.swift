//
//  Product.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/19/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct Product {
    // 13
    let id: String
    let shopId: String
    var name: String
    var price: Int
    var rating: Double
    var image: String
    var categories: [String]
    var brand: String?
    var sold: Int // historical_sold
    var stock: Int
    var discount: String?
    var maxPrice: Int
    var minPrice: Int

    var inventory: Int?
    var ratingArray = [Int?]()
    var soldPrice: String?
    
//    func convertPriceToVietnameseCurrency(price: Int) -> String? {
//        let formatter = NumberFormatter()
//        let priceInVietNam = price as NSNumber?
//        formatter.numberStyle = .currency
//        formatter.locale = Locale(identifier: "vi_VN")
//        print(formatter.string(from: priceInVietNam!)!)
//        return formatter.string(from: priceInVietNam!)
//    }

    init(id: String, shopId: String, name: String, price: Int, rating: Double, image: String, categories: [String], brand: String?, sold: Int, stock: Int, discount: String?, maxPrice: Int, minPrice: Int) {
        self.id = id
        self.name = name
        self.shopId = shopId
        self.rating = rating
        self.price = price
        self.image = image
        self.categories = categories
        self.brand = brand
        self.sold = sold
        self.stock = stock
        self.discount = discount
        self.maxPrice = maxPrice
        self.minPrice = minPrice
    }
}
