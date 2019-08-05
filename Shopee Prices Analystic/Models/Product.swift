//
//  Product.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/19/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct Product {
    var name: String?
    var description: String?
    var price: Int?
    var rating: Double?
    
    func convertPriceToVietnameseCurrency() -> String? {
        let formatter = NumberFormatter()
        let priceInVietNam = price as NSNumber?
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
        print(formatter.string(from: priceInVietNam!)!)
        return formatter.string(from: priceInVietNam!)
    }
}
