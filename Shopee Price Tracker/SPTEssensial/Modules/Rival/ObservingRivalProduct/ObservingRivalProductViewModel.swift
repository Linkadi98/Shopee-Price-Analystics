//
//  ObservingRivalProductViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/9/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct ObservingRivalProductViewModel {
    let rivalResponse: Observable<[RivalsResponse]>?
    
    let currentShopProduct: Product?
    
    var hud: SPTProgressHUD?
    
    func fetchDataFromServer(completion: @escaping (ConnectionResults, [RivalsResponse]?) -> Void) {
        RivalApiService.getChosenRivals(shopId: currentShopProduct?.shopid ?? 0, productId: currentShopProduct?.itemid ?? 0, completion: completion)
    }
    
    init(rivalResponse: Observable<[RivalsResponse]>, currentShopProduct: Product) {
        self.rivalResponse = rivalResponse
        self.currentShopProduct = currentShopProduct
    }
}
