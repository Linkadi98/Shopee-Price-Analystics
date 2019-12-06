//
//  ProductTableContainerViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/23/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation


class ProductTableContainerViewModel {
    var product: Observable<Product>?
    
    func observeProductPrice(completion: @escaping (ConnectionResults) -> Void) {
        // TODO:
//        PriceApiService.priceObservations(productId: <#T##Int#>, completion: <#T##(ConnectionResults, [String]?, [Int]?) -> Void#>)
    }
    
    func getCompetitorsHasSameProduct() {
        // TODO:
    }
}
