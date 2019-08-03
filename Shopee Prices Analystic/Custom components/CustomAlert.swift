//
//  EUIAlert.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/3/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class CustomPasswordConfirmAlert: UIAlertController {
    var passwordField: UITextField
    
    init(title: String, message: String) {
        super.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        
    }
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
