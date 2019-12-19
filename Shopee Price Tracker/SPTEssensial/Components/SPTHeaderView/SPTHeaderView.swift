//
//  SPTHeaderView.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/17/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class SPTHeaderView: BaseView {

    let XIB_NAME = "SPTHeaderView"
    
    override func commonInit() {
        let bundle = Bundle.init(for: SPTHeaderView.self)
        if
            let viewsToAdd = bundle.loadNibNamed(XIB_NAME,
                                                 owner: self,
                                                 options: nil),
            let contentView = viewsToAdd.first as? UIView {
            
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight,
                                            .flexibleWidth]
        }
    }
}
