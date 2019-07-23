//
//  UITextFieldExtension.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

extension UITextField {
    
    open func createUnderlineTextField() {
        print(layer.frame.width)
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: frame.height + 10, width: frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        
        layer.addSublayer(bottomLine)
    }
    
    open func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 5, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func isValidUserName() -> Bool {
        guard let userName = self.text else {
            return false
        }
        
        if userName.count > 5 && userName.contains("@") && userName.contains("gmail") {
            return true
        }
        else {
            return false
        }
        
    }
    
    
}








