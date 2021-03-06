//
//  UIView.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/20/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

extension UIView {
    
    func setShadow(cornerRadius: CGFloat = 8, shadowRadius: CGFloat = 5, shadowOffset: CGSize = CGSize(width: 0, height: 0.5)) {
        layer.cornerRadius = cornerRadius
        layer.shadowOpacity = 0.2
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }
    
    
    func setShadowForButtonOnboarding() {
        layer.cornerRadius = frame.height / 2
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
    }
    
    func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 10
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
    }
    
    func translucent() {
        self.layer.cornerRadius = 10
        self.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.contentView.layer.cornerRadius = 10
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(blurView, at: 0)
        
        blurView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.contentView.layer.cornerRadius = 10
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        blurView.contentView.addSubview(vibrancyView)
        
        vibrancyView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
    }
    
//    func setCorners(cornerRadius: CGFloat = 10, _ corners: [Corners]) {
//        
//        layer.cornerRadius = cornerRadius
//        
//        var maskedCorners = [CACornerMask]()
//        
//        for corner in corners {
//            switch corner {
//            case .topLeft:
//                maskedCorners.append(.layerMinXMinYCorner)
//            case .topRight:
//                maskedCorners.append(.layerMaxXMinYCorner)
//            case .bottomLeft:
//                maskedCorners.append(.layerMaxXMinYCorner)
//            case .bottomRight:
//                maskedCorners.append(.layerMaxXMaxYCorner)
//            }
//        }
//        
//        layer.maskedCorners = 
//    }
    
    
    
    
}

enum Corners {
    case topLeft, topRight, bottomLeft, bottomRight
}
