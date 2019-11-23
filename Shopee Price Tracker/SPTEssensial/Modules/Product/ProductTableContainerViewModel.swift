//
//  ProductTableContainerViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/23/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

protocol ProductTableContainerProtocol {
    func getProduct() -> Product
}

class ProductTableContainerViewModel {
    var product: Observable<Product>?
    
    var delegate: ProductTableContainerProtocol?
    
    func setProduct() {
        if let product = delegate?.getProduct() {
            self.product?.value = product
        }
    }
}
