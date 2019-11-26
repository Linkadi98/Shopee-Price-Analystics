//
//  ListRivalsViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/24/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

class ListRivalsViewModel {
    
    var product: Product?
    var listSearchedRivals: [(Product, Bool)]?
    var listRivalsShops: [Shop]?

    func getListRivals(myShopId: String, myProductId: String, completion: @escaping (ConnectionResults, [(Product, Bool)]?) -> Void) {
        RivalApiService.getListRivals(myShopId: myShopId, myProductId: myProductId, completion: completion)
    }
}
