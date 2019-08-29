//
//  Notifications.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/28/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didChangeCurrentShop = Notification.Name(rawValue: "didChangeCurrentShop")
    
    static let didSignedInApp = Notification.Name(rawValue: "didSignedInApp")
    
    static let didAppearChosenProduct = Notification.Name(rawValue: "didAppearChosenProduct")

    static let didSwitchAutoUpdate = Notification.Name(rawValue: "didSwitchAutoUpdate")

    static let didReceivedStatistics = Notification.Name(rawValue: "didReceivedStatistics")
    
    static let didChooseRival = Notification.Name(rawValue: "didChooseRival")
}
