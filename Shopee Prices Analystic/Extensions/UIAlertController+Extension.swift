//
//  EUIAlert.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/3/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func createCustomPasswordConfirmAlert(viewController: UIViewController, username: String, shop: Shop) {
        
        addTextField(configurationHandler: {(passwordField) in
            passwordField.placeholder = "Nhập mật khẩu của shop"
            passwordField.isSecureTextEntry = true
            
            passwordField.borderStyle = .none
            
        })
        
        addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { _ in
            print("Đã huỷ")
        }))
        addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let vc = viewController as? ListShopsTableViewController {
                UIApplication.shared.beginIgnoringInteractionEvents()

                let activityIndicator = vc.initActivityIndicator()
                vc.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()

                vc.checkAccount(username: username, password: self.textFields![0].text!, completion: { change in
                    if change {
                        vc.changeCurrentShop(newShop: shop)
                        vc.fetchingDataFromServer()
                        vc.tableView.reloadData()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        activityIndicator.stopAnimating()
                        if activityIndicator.isAnimating == false {
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    }
                })
            }
            
//            present(
        }))
    }
    
    func createCustomEditingPriceAlert() {
        addTextField(configurationHandler: {(priceField) in
            priceField.placeholder = "Nhập giá cần thay đổi"
            priceField.borderStyle = .none
            
        })
        
        addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
    }
    
}
