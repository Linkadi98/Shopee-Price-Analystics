//
//  Product.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/19/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct Product {
    let id: String?
    let shopId: String?
    var name: String?
    var price: Int?
    var rating: Double?
    var image: String?
    var shopName: String?
    
    var brand: String?
    var soldItem: Int?
    var inventory: Int?
    var ratingArray = [Int?]()
    var category = [String?]()
    
    var soldPrice: String?
    var maxPrice: String?
    var minPrice: String?
    var discountPercent: String?
    
    
    func convertPriceToVietnameseCurrency() -> String? {
        let formatter = NumberFormatter()
        let priceInVietNam = price as NSNumber?
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
        print(formatter.string(from: priceInVietNam!)!)
        return formatter.string(from: priceInVietNam!)
    }
    
    init(id: String, shopId: String, name: String, price: Int, rating: Double, image: String) {
        self.id = id
        self.name = name
        self.shopId = shopId
        self.rating = rating
        self.price = price
        self.image = image
    }
}
