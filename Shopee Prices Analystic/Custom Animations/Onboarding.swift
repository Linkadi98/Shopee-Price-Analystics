//
//  Onboarding.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

extension UIView {
    
    static func changeImage(with imageView: UIImageView, to img: UIImage, nextAnimation: @escaping () -> Void) {
        UIView.transition(with: imageView, duration: 1, options: .transitionCrossDissolve, animations: {
            imageView.image = img
        }, completion: { _ in
            nextAnimation()
        })
    }
    
    static func animatedButton(with button: UIButton, x: CGFloat = 0, y: CGFloat = 0, alphaBefore: CGFloat = 0, alphaAfter: CGFloat = 1, duration: Double = 0.5, nextAnimation: (() -> Void)? = nil){
        button.alpha = alphaBefore
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            button.alpha = alphaAfter
            button.transform = CGAffineTransform(translationX: x, y: y)
            
        }) { _ in
            if let animation = nextAnimation {
                animation()
            }
        }
    }
    
    static func changeText(of label: UILabel, with text: String, nextAnimation: (() -> Void)? = nil) {
        UIView.transition(with: label, duration: 1.5, options: .transitionFlipFromBottom, animations: {
            label.text = text
        }, completion: { _ in
            if let animation = nextAnimation {
                animation()
            }
        })
    }
    
    static func zoomInImage(with image: UIImageView, nextAnimation: @escaping () -> Void) {
        image.isHidden = false
        image.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 1.5, animations: {
            image.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            nextAnimation()
        })
    }
}

