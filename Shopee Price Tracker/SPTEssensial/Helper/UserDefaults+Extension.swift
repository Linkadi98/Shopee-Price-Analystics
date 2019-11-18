//
//  UserDefault+Extension.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(Date(timeIntervalSinceNow: 21600), forKey: "expiredTimeOfToken")
        Network.shared.headers["Authorization"] = token
    }
    
    func saveObjectInUserDefaults(object: AnyObject, forKey key: String) {
        switch key {
        case "currentUser":
            if let currentUser = object as? User {
                if let encoded = try? JSONEncoder().encode(currentUser) {
                    UserDefaults.standard.set(encoded, forKey: "currentUser")
                }
            } else {
                print("Object didn't match key")
            }
        case "currentShop":
            if let currentShop = object as? Shop {
                if let encoded = try? JSONEncoder().encode(currentShop) {
                    UserDefaults.standard.set(encoded, forKey: "currentShop")
                }
            } else {
                print("Object didn't match key")
            }
        default: break
        }
    }
    
    func getObjectInUserDefaults(forKey key: String) -> AnyObject? {
        if let data = UserDefaults.standard.data(forKey: key) {
            switch key {
            case "currentUser":
                if let currentUser = try? JSONDecoder().decode(User.self, from: data) {
                    return currentUser as AnyObject
                }
            case "currentShop":
                if let currentShop = try? JSONDecoder().decode(Shop.self, from: data) {
                    return currentShop as AnyObject
                }
            default: break
            }
        }
        return nil
    }
}
