//
//  OverviewViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/15/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

class OverviewViewModel {
    var response: Observable<(Int, Int, Int)>?
    
    func fetchDataFromServer(completion: @escaping (Int, Int, Int) -> Void) {
        guard let currentShop = UserDefaults.standard.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
            return
        }
        
        ProductApiService.getListProducts(completion: { result, products in
            guard result != .failed, let products = products else {
                completion(0, 0, 0)
                return
            }
            
            let totalShopProducts = products.count
            
            PriceApiService.getChosenProducts(shopId: currentShop.shopid ?? 0, completion: { result, products in
                guard result != .failed, let products = products else {
                    completion(0, 0, 0)
                    return
                }
                
                let filterProducts = products.filter { $0.auto! == true }
                
                completion(totalShopProducts, filterProducts.count, products.count)
            })
        })
    }
    
    init(response: Observable<(Int, Int, Int)>) {
        self.response = response
    }
}
