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
    var listSearchedRivals: Observable<[(Product, Shop, Bool)]>?
    
    
    var hud: SPTProgressHUD?

    func getListRivals(myProductId: Int, completion: @escaping (ConnectionResults, [(Product, Shop, Bool)]?) -> Void) {
        RivalApiService.getListRivals(myShopId: product?.value.shopid ?? 0, myProductId: myProductId, completion: completion)
    }
    
    func getListRivalShops(myShopId: Int, myProductId: Int, completion: @escaping ([Shop]?) -> Void) {
        RivalApiService.getListRivalsShops(myShopId: myShopId, myProductId: myProductId, completion: completion)
    }
    
    func chooseRival(myProductId: Int, myShopId: Int, rivalProductId: Int, rivalShopId: Int, autoUpdate: Bool, priceDiff: Double, from: Double, to: Double, completion: @escaping (ConnectionResults) -> Void) {
        RivalApiService.chooseRival(myProductId: myProductId, myShopId: myShopId, rivalProductId: rivalProductId, rivalShopId: rivalShopId, autoUpdate: autoUpdate, priceDiff: priceDiff, from: from, to: to, completion: completion)
    }
    
    init(product: Observable<Product>?, foundRivalProducts: Observable<[(Product, Shop, Bool)]>) {
        self.product = product
        self.listSearchedRivals = foundRivalProducts
    }
}
