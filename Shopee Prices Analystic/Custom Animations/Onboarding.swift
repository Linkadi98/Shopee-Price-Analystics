//
//  Onboarding.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

extension UIView {
    
    static func changeImage(with imageView: UIImageView, to img: UIImage) {
        UIView.transition(with: imageView, duration: 1, options: .transitionFlipFromBottom, animations: {
            imageView.image = img
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
        UIView.transition(with: label, duration: 1.5, options: .transitionCrossDissolve, animations: {
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
    
    static func animatedTextChanged(with button: UIButton, text: String) {
        UIView.transition(with: button, duration: 0.6, options: .transitionCrossDissolve, animations: {
            button.setTitle(text, for: .normal)
        }, completion: nil)
    }
    
    static func translateX(view: UIView, nextAnimation: (() -> Void)? = nil) {
        view.transform = CGAffineTransform(translationX: -20, y: 0)
        view.alpha = 0
        UIView.animate(withDuration: 1.2, delay: 0.05, animations: {
            view.transform = .identity
            view.alpha = 1
        }, completion: { _ in
            if let animation = nextAnimation {
                animation()
            }
        })
    }
    
    static func translateAndChangeLabelText(with label: UILabel, text: String, direction: Direction) {
        let factor: CGFloat
        switch direction {
        case .left:
            factor = -1
        default:
            factor = 1
        }
        label.alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            label.transform = CGAffineTransform(translationX: factor * 500, y: 0)
        }, completion: { _ in
            label.transform = CGAffineTransform(translationX:  -factor * 500, y: 0)
            label.text = text
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                label.transform = .identity
            }, completion: nil)
        })
    }
}

enum Direction: CGFloat {
    case left, right
}

