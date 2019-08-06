//
//  AlamofireMager.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 8/6/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireManager {
    let manager: SessionManager

    init(timeoutInterval: TimeInterval) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest =  timeoutInterval// seconds
        configuration.timeoutIntervalForResource = timeoutInterval
        self.manager =  Alamofire.SessionManager(configuration: configuration)
    }
}

