//
//  SPTListShopsViewModel.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/15/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

class SPTListShopsViewModel {
    var shops: Observable<[Shop]>?
    
    func fetchShops(completion: @escaping (ConnectionResults, [Shop]?) -> Void) {
        ShopApiService.getListShops(completion: completion)
    }
    
    init(shops: Observable<[Shop]>) {
        self.shops = shops
    }
}
