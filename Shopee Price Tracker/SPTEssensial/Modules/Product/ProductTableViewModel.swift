//
//  ProductTableViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

class ProductTableViewModel {
    
    var currentShop: Shop?
    var productsList: [Product]?
    var filterProducts: [Product]?
        
    func fetchProductFromServer(completion: @escaping (ConnectionResults, [Product]?) -> Void) {
        ProductApiService.getListProducts(completion: completion)
    }
    
    func updateProductPrice(shopId: String, productId: String, newPrice: Int, completion: @escaping (ConnectionResults) -> Void) {
        ProductApiService.updatePrice(shopId: shopId, productId: productId, newPrice: newPrice, completion: completion)
    }
}
