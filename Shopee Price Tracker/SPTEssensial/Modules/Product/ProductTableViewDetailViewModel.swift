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
    var currentShop: Observable<Shop>
    
    func updateProductPrice(shopId: String, productId: String, newPrice: Int, completion: @escaping (ConnectionResults) -> Void) {
        ProductApiService.updatePrice(shopId: shopId, productId: productId, newPrice: newPrice, completion: completion)
    }
    
    init(product: Observable<Product>, currentShop: Observable<Shop>) {
        self.product = product
        self.currentShop = currentShop
    }
    
    func updatePrice(newPrice: Int, completion: @escaping (ConnectionResults) -> Void) {
        ProductApiService.updatePrice(shopId: currentShop.value.shopId, productId: product.value.id!, newPrice: newPrice, completion: completion)
    }
}
