//
//  EUIAlert.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/3/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func createCustomPasswordConfirmAlert() {
        
        
        addTextField(configurationHandler: {(passwordField) in
            passwordField.placeholder = "Nhập mật khẩu của shop"
            passwordField.isSecureTextEntry = true
            
            passwordField.borderStyle = .none
            
        })
        
        addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            print("chuyển shop")
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
