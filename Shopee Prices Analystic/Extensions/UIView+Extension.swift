//
//  UIView.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/20/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

extension UIView {
    
    func setShadow() {
        layer.cornerRadius = 10
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
    
    
    func setCornerLogo() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "overview"))
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints({ make in
            make.trailing.equalToSuperview().inset(6)
            make.top.equalToSuperview().inset(6)
            
            make.width.equalTo(20)
            make.height.equalTo(20)
            
        })
    }
    
}
