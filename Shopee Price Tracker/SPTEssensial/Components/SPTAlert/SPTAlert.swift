//
//  SPTAlert.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/8/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

enum SPTAlertStyle {
    case submit
}

class SPTAlert {
    
    func show(style: SPTAlertStyle, title: String = "Lỗi", message: String, in view: UIViewController, handler: @escaping ((UIAlertAction) -> Void)) {
        switch style {
        
        case .submit:
            submitAlert(title: title, message: message, in: view, handler: handler)
        }
    }
    
    
    private func submitAlert(title: String = "Lỗi", message: String, in view: UIViewController, handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: handler)
        let cancelButton = UIAlertAction(title: "Huỷ", style: .destructive, handler: nil)
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        
        view.present(alert, animated: true, completion: nil)
    }
}
