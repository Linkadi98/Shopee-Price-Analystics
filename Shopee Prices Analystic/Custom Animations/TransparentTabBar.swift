//
//  TransparentTabBar.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/17/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class TransparentTabBar: UITabBar {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        frost.frame = bounds
        frost.autoresizingMask = .flexibleWidth
        insertSubview(frost, at: 0)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
