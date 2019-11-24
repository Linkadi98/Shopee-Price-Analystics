//
//  RivalApiService.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/24/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

struct RivalApiService {
    
    func getListRivals(myShopId: String, myProductId: String, completion: @escaping (ConnectionResults, [(Product, Bool)]?, Int?) -> Void) {
        // rival, isChosen, numberOFRivals
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivals_path + "/\(myShopId)/\(myProductId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 60).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                sharedNetwork.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil, nil)
                return
            }
            
            //Successful request
            self.getChosenRivals(shopId: myShopId, productId: myProductId) { (result, chosenRivals) in
                guard result != .failed, let chosenRivals = chosenRivals else {
                    completion(.failed, nil, nil)
                    return
                }
                
                var listSearchedRivals: [(Product, Bool)] = []
                let responseValue = response.result.value! as! [[String: Any]]
                if responseValue.isEmpty {
                    print("So doi thu: \(listSearchedRivals.count)")
                    completion(.success, [], 0)
                    return
                }
                for value in responseValue {
                    let rival = self.decodeProductJson(value: value)
                    var isChosen = false
                    for chosenRival in chosenRivals {
                        if chosenRival.0.id == rival.id {
                            isChosen = true
                            break
                        }
                    }
                    listSearchedRivals.append((rival, isChosen))
                }
                
                var numberOfRivals = 0
                for searchedRival in listSearchedRivals {
                    if searchedRival.1 {
                        numberOfRivals += 1
                    }
                }
                
                print("So doi thu: \(listSearchedRivals.count)")
                completion(.success, listSearchedRivals, numberOfRivals)
            }
            
        }
    }
    
    func getListRivalsShops(myShopId: String, myProductId: String, completion: @escaping ([Shop]?) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivalsShops_path + "/\(myShopId)/\(myProductId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 30).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                print("Error when fetching data: \(response.result.error)")
                StatusBarNotificationBanner(title: "Lỗi kết nối, vui lòng thử lại sau", style: .danger).show()
                completion(nil)
                return
            }
            
            //Successful request
            var listRivalsShops: [Shop] = []
            let responseValue = response.result.value! as! [[String: Any]]
            for value in responseValue {
                listRivalsShops.append(self.decodeShopJson(value: value)) // need edited
            }
            print("So shop doi thu: \(listRivalsShops.count)")
            completion(listRivalsShops)
        }
    }
    
    // choose rival
    func chooseRival(myProductId: String, myShopId: String, rivalProductId: String, rivalShopId: String, autoUpdate: Bool, priceDiff: Int, from min: Int, to max: Int, completion: @escaping (ConnectionResults) -> Void) {
        let sharedNetwork = Network.shared
        let url = URL(string: Network.shared.base_url + Network.shared.rival_path)!
        let parameters: Parameters = [
            "itemid": myProductId,
            "shopid": myShopId,
            "rivalShopid": rivalShopId,
            "rivalItemid": rivalProductId,
            "auto": autoUpdate,
            "price": priceDiff,
            "max": max,
            "min": min
        ]
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .post, parameters: parameters).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed)
                return
            }
            
            //Successful request
            completion(.success)
        }
    }
    
    // Get chosen products
    func getChosenProducts(shopId: String, completion: @escaping (ConnectionResults, [(Product, Int, Bool)]?) -> Void) {
        // result, product, numberOfChosenRivals, autoUpdate
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.chosenProducts_path + "/\(shopId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }
            
            //Successful request
            var chosenProducts: [(Product, Int, Bool)] = []
            let responseValue = response.result.value! as! [[String: Any]]
            for value in responseValue {
                let product = self.decodeProductJson(value: value)
                
                let numberOfChosenRivals = value["chosen"] as! Int
                let autoUpdate = value["auto"] as! Bool
                
                chosenProducts.append((product, numberOfChosenRivals, autoUpdate))
            }
            completion(.success, chosenProducts)
        }
    }
    
    // Get chosen rivals
    func getChosenRivals(shopId: String, productId: String, completion: @escaping (ConnectionResults, [(Product, Shop, Observation)]?) -> Void) {
        // product, shop rivals, numberOfChosenRivals, autoUpdate
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.chosenRivals_path + "/\(shopId)/\(productId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }
            
            //Successful request
            var chosenRivals: [(Product, Shop, Observation)] = []
            let responseValue = response.result.value! as! [[String: Any]]
            let count = responseValue.count
            var i = 0
            if responseValue.isEmpty {
                completion(.success, chosenRivals)
            }
            for value in responseValue {
                let rival = self.decodeProductJson(value: value["itemRival"] as! [String: Any])
                let observation = self.decodeObservationJson(value: value["rival"] as! [String: Any])
                
                self.getRivalsShop(shopId: observation.rivalShopId) { (result, rivalsShop) in
                    guard result != .failed, let rivalsShop = rivalsShop else {
                        completion(.failed, nil)
                        return
                    }
                    
                    chosenRivals.append((rival, rivalsShop, observation))
                    i += 1
                    if i == count {
                        completion(.success, chosenRivals)
                    }
                }
            }
        }
    }
    
    // Get rivals' shops info
    func getRivalsShop(shopId: String, completion: @escaping (ConnectionResults, Shop?) -> Void) {
        // shop rivals, product, numberOfChosenRivals, autoUpdate
        let sharedNetwork = Network.shared
        let url = URL(string: sharedNetwork.base_url + sharedNetwork.rivalsShopInfo_path + "/\(shopId)")!
        
        sharedNetwork.alamofireDataRequest(url: url, httpMethod: .get, parameters: nil, timeoutInterval: 60).responseJSON { (response) in
            // Failed request
            guard response.result.isSuccess else {
                self.notifyFailedConnection(error: response.result.error)
                completion(.failed, nil)
                return
            }
            
            //Successful request
            let responseValue = response.result.value! as! [String: Any]
            completion(.success, self.decodeShopJson(value: responseValue))
        }
    }
}
