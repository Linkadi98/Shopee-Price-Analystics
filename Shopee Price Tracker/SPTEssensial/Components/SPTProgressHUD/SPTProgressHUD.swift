//
//  SPTProgressHUD.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/28/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import JGProgressHUD
import UIKit

class SPTProgressHUD: JGProgressHUD {
    
    enum Result {
        case success, error, failed
    }
    
    func show(in tableView: UITableView, content: String) {
        textLabel.text = content
        tableView.backgroundView = UIView()
        
        show(in: tableView.backgroundView!)
    }
    
    func showStatusHUD(in tableView: UITableView, result: Result, content: String) {
        
        switch result {
        case .success:
            indicatorView = JGProgressHUDSuccessIndicatorView()
            show(in: tableView, content: content)
        case .error, .failed:
            indicatorView = JGProgressHUDErrorIndicatorView()
            show(in: tableView, content: content)
        }
        
        dismiss(afterDelay: 10)
        tableView.backgroundView = nil
    }
    
    func show(in view: UIView, content: String) {
        textLabel.text = content
        show(in: view)
    }
    
}
