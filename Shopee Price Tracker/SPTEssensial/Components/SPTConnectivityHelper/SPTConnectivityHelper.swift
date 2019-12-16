//
//  SPTConnectivityHelper.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/14/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import Connectivity

protocol SPTConnectivityProtocol {
    func invoke()
    func notifyAllViews(with connectionStatus: Connectivity.Status)
    func destroy()
}

protocol SPTConnectivityDelegate {
    func update(with connection: Connectivity.Status)
}

class SPTConnectivityHelper: SPTConnectivityProtocol {
    private let connectivity = Connectivity()
    
//    var delegate: SPTConnectivityDelegate?
    func invoke() {
        if #available(iOS 12, *) {
            connectivity.framework = .network
        }
        else {
            connectivity.framework = .systemConfiguration
        }
        fireCheckConnectivity()
        configureConnectivityNotifier()
        connectivity.startNotifier()
    }
    
    func configureConnectivityNotifier() {
        let connectivityChanged: (Connectivity) -> Void = { [unowned self] connectivity in
            self.notifyAllViews(with: connectivity.status)
        }
        connectivity.whenConnected = connectivityChanged
        connectivity.whenDisconnected = connectivityChanged
    }
    
    func fireCheckConnectivity() {
        connectivity.checkConnectivity { connectivity in
            print(connectivity.status)
            self.notifyAllViews(with: connectivity.status)
        }
    }
    
    func notifyAllViews(with connectionStatus: Connectivity.Status) {
        let notificationCenter = NotificationCenter.default
        
        switch connectionStatus {
        case .connected,
             .connectedViaCellular,
             .connectedViaWiFi,
             .determining:
            
            notificationCenter.post(name: .internetAccess, object: nil)
        case .connectedViaCellularWithoutInternet,
             .connectedViaWiFiWithoutInternet,
             .notConnected:
            
            notificationCenter.post(name: .noInternetAccess, object: nil)
        }
        
    }
    
    func destroy() {
        connectivity.stopNotifier()
    }
}


