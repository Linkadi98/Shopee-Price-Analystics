//
//  StatTableViewViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/8/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct StatTableViewViewModel {
    var product: Product
    var data: Observable<([Int], Int)>?
    
    func fetchDataFromServer(completion: @escaping (ConnectionResults, [Int]?, Int?) -> Void) {
        PriceApiService.getStatistics(product: product, completion: completion)
    }
}
