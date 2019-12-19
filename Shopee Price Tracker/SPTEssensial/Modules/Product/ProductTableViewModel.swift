//
//  ProductTableViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

class ProductTableViewModel {
    
//    var currentShop: Observable<Shop>
    var productsList: Observable<[Product]?>
    var filterProducts: Observable<[Product]?>
    var productIndex: Int?
      
    func fetchProductFromServer(completion: @escaping (ConnectionResults, [Product]?) -> Void) {
        ProductApiService.getListProducts(completion: completion)
    }
    
    init(productList: Observable<[Product]?>, filterProducts: Observable<[Product]?>) {
        self.productsList = productList
        self.filterProducts = filterProducts
    }
    
    
}
