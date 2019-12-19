//
//  RivalProductDetailViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/12/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct RivalProductDetailViewModel {
    var rivalProduct: Observable<Product>?
    var rivalShop: Observable<Shop>?
    
    var currentShopProduct: Product?
    var status: Bool?
    
    var hud: SPTProgressHUD?
    
    func addRivalPrductToListObservedProduct(completion: @escaping (ConnectionResults) -> Void) {
        RivalApiService.chooseRival(myProductId: currentShopProduct?.itemid ?? 0,
                                    myShopId: currentShopProduct?.shopid ?? 0,
                                    rivalProductId: rivalProduct?.value.itemid ?? 0,
                                    rivalShopId: rivalProduct?.value.shopid ?? 0,
                                    completion: completion)
    }
    
    func deleteChosenRival(completion: @escaping (ConnectionResults) -> Void) {
        PriceApiService.deleteRivals(productId: rivalProduct?.value.itemid ?? 0,
                                     completion: completion)
    }
}
