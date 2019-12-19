//
//  File.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/9/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

class PriceTrackingShopProductViewModel {
    var observedShopProduct: Observable<[Product]>?
    
    var hud: SPTProgressHUD?
    
    func fetchDataFromServer(completion: @escaping (ConnectionResults, [Product]?) -> Void) {
        guard let currentShop = UserDefaults.standard.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            return
        }
        print(currentShop)
        PriceApiService.getChosenProducts(shopId: currentShop.shopid ?? 0, completion: completion)
    }
    
    init(observedShopProduct: Observable<[Product]>) {
        self.observedShopProduct = observedShopProduct
    }
}
