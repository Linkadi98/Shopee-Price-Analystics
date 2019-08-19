//
//  File.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/17/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class Transition: UIView {
    
    func fadeTransition(view: UIView) {
        view.alpha = 0
        UIView.animate(withDuration: 2, animations: {
            view.alpha = 1
        })
    }
    
    func translateXAxis(view: UIView) {
        let screen = UIScreen.main.bounds
        
        view.frame.origin.x = -screen.width
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
            
        }, completion: nil)
    }
}
