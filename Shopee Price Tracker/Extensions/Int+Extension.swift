//
//  Int+Extension.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/21/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

extension Int {
    func convertPriceToVietnameseCurrency() -> String? {
        let formatter = NumberFormatter()
        let priceInVietNam = self as NSNumber?
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
        print(formatter.string(from: priceInVietNam!)!)
        return formatter.string(from: priceInVietNam!)
    }
}
