//
//  SPTself.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/17/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation
import BadgeSwift
import SnapKit

class SPTBadge: BadgeSwift {
    
    var badgeValue: Observable<Int>?
    
    func attachTo(_ parentView: UIView) {
        self.badgeValue = Observable(0)
        parentView.addSubview(self)
        configureBadge()
        positionBadge(value: (self.badgeValue?.value)!)
    }
    
    private func configureBadge() {
        
        // Insets
        
        badgeValue?.bindAndFire { badgeValue in
            if badgeValue < 0 {
                self.text = "0"
            }
            if badgeValue >= 100 {
                self.text = "99+"
                self.positionBadge(value: 100)
            }
            else {
                self.text = String(describing: badgeValue)
            }
        }
        
        
        self.insets = CGSize(width: 1, height: 1)
        
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        // Font
        self.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        // Text color
        self.textColor = UIColor.white
        
        // Badge color
        self.badgeColor = UIColor.red
        
        // No shadow
        self.shadowOpacityBadge = 0
        
        // Border width and color
        self.borderWidth = 0
    }
    
    private func positionBadge(value: Int) {
        if value >= 100 {
            self.snp.remakeConstraints { remake in
                remake.trailing.equalToSuperview().inset(-15)
                remake.top.equalToSuperview().inset(-6)
            }
            return
        }
        self.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(-5)
            make.top.equalToSuperview().inset(-6)
        }
    }
}
