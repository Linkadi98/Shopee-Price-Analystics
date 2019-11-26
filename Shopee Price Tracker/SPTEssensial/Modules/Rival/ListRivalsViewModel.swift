//
//  ListRivalsViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/24/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

class ListRivalsViewModel {
    
    var product: Observable<Product>?
    var listSearchedRivals: Observable<[(Product, Bool)]>?
    var listRivalShops: Observable<[Shop]>?

    func getListRivals(myShopId: Int, myProductId: Int, completion: @escaping (ConnectionResults, [(Product, Bool)]?) -> Void) {
        RivalApiService.getListRivals(myShopId: myShopId, myProductId: myProductId, completion: completion)
    }
    
    func getListRivalShops(myShopId: Int, myProductId: Int, completion: @escaping ([Shop]?) -> Void) {
        RivalApiService.getListRivalsShops(myShopId: myShopId, myProductId: myProductId, completion: completion)
    }
    
    func chooseRival(myProductId: Int, myShopId: Int, rivalProductId: Int, rivalShopId: Int, autoUpdate: Bool, priceDiff: Int, from: Int, to: Int, completion: @escaping (ConnectionResults) -> Void) {
        RivalApiService.chooseRival(myProductId: myProductId, myShopId: myShopId, rivalProductId: rivalProductId, rivalShopId: rivalShopId, autoUpdate: autoUpdate, priceDiff: priceDiff, from: from, to: to, completion: completion)
    }
}
