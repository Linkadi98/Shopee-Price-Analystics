//
//  ProductTableViewDetailViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/19/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

class ProductTableViewDetailViewModel {
    var product: Observable<Product>
    
    init(product: Observable<Product>) {
        self.product = product
    }
    
    func updatePrice(newPrice: Int, completion: @escaping (ConnectionResults) -> Void) {
        ProductApiService.updatePrice(shopId: product.value.shopid!, productId: product.value.itemid!, newPrice: newPrice, completion: completion)
    }
}
