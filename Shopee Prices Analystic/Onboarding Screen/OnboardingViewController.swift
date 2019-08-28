//
//  PriceOnboardingViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/17/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit


class OnboardingViewController: UIViewController {

    // MARK: - Properties
    
    let text = [
        "THEO DÕI GIÁ": "Hỗ trợ theo dõi giá của sản phẩm trên sàn Thương mại điện tử Shopee",
        "THEO DÕI ĐỐI THỦ": "Giúp người bán hàng theo dõi và điều chỉnh giá của sản phẩm chủ động theo đối thủ",
        "THỐNG KÊ TRỰC QUAN": "Biểu đồ thống kê thay đổi giá trực quan",
        "QUẢN LÝ SẢN PHẨM": "Quản lý sản phẩm trong cửa hàng của bạn một cách dễ dàng và tập trung",
        "BẮT KỊP ĐỐI THỦ CỦA BẠN": "Đăng ký hoặc đăng nhập ngay"
    ]
    
    
    var pageIndex: Int = 0
    
    let posX: CGFloat = 75
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.alpha = 0
            registerButton.transform = CGAffineTransform(translationX: 0, y: 50)
            registerButton.setShadowForButtonOnboarding()
        }
    }
    @IBOutlet weak var loginButton: UIButton!  {
        didSet {
            loginButton.alpha = 0
            loginButton.transform = CGAffineTransform(translationX: 0, y: 50)
            loginButton.setShadowForButtonOnboarding()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleOnboarding: UILabel!
    @IBOutlet weak var descriptionOnboarding: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeDown)
        
        configPositionAtBegining()
        
        UIView.zoomOutImage(with: imageView, nextAnimation: {
            UIView.animate(withDuration: 0.9, animations: {
                self.titleOnboarding.alpha = 1
                self.titleOnboarding.transform = .identity
            }, completion: { _ in
                UIView.animate(withDuration: 1.1, animations: {
                    self.descriptionOnboarding.alpha = 1
                    self.descriptionOnboarding.transform = .identity
                }, completion: { _ in
                    self.nextButton.isEnabled = true
                })
            })
        })
        
        UIView.translateX(view: nextButton) { [unowned self] in
            UIView.translateX(view: self.pageControl) { [unowned self] in
                UIView.translateX(view: self.skipButton)
            }
        }
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                onboardToLeft()
            
            case UISwipeGestureRecognizer.Direction.left:
                onboardToRight()
            
            default:
                break
            }
        }
    }
    // MARK: - Actions
    
    @IBAction func goToNextView(_ sender: Any) {
        onboardToRight()
    }
    
    @IBAction func goBackPreviousView(_ sender: Any) {
        onboardToLeft()
    }
    
    
    // MARK: - show onboarding image to left and right
    
    private func onboardToRight() {
        if pageIndex < 5 {
            pageIndex += 1
            pageControl.currentPage = pageIndex
        }
        
        switch pageIndex {
        case 1:
            UIView.translateAndChangeLabelText(with: titleOnboarding, text: "THEO DÕI ĐỐI THỦ", direction: .left)
            
            UIView.translateAndChangeLabelText(with: descriptionOnboarding, text: text["THEO DÕI ĐỐI THỦ"]!, direction: .left)
            
            showLeftArrow()
            UIView.translateImage(with: imageView, to: UIImage(imageLiteralResourceName: "rival"), direction: .left)
            
            
        case 2:
            UIView.translateAndChangeLabelText(with: titleOnboarding, text: "THỐNG KÊ TRỰC QUAN", direction: .left)
            
            UIView.translateAndChangeLabelText(with: descriptionOnboarding, text: text["THỐNG KÊ TRỰC QUAN"]!, direction: .left)
            UIView.translateImage(with: imageView, to: UIImage(imageLiteralResourceName: "chart"), direction: .left)
        case 3:
            UIView.translateAndChangeLabelText(with: titleOnboarding, text: "QUẢN LÝ SẢN PHẨM", direction: .left)
            
            UIView.translateAndChangeLabelText(with: descriptionOnboarding, text: text["QUẢN LÝ SẢN PHẨM"]!, direction: .left)
            UIView.translateImage(with: imageView, to: UIImage(imageLiteralResourceName: "product image"), direction: .left)
        default:
            UIView.translateAndChangeLabelText(with: titleOnboarding, text: "BẮT KỊP ĐỐI THỦ CỦA BẠN", direction: .left)
            
            UIView.translateAndChangeLabelText(with: descriptionOnboarding, text: text["BẮT KỊP ĐỐI THỦ CỦA BẠN"]!, direction: .left)
            UIView.translateImage(with: imageView, to: UIImage(imageLiteralResourceName: "shop image"), direction: .left)
            
            hideRightArrow()
        }
    }
    
    private func onboardToLeft() {
        pageIndex -= 1
        pageControl.currentPage = pageIndex
        
        switch pageIndex {
        case 3:
        UIView.translateAndChangeLabelText(with: titleOnboarding, text: "QUẢN LÝ SẢN PHẨM", direction: .right)
        
        UIView.translateAndChangeLabelText(with: descriptionOnboarding, text: text["QUẢN LÝ SẢN PHẨM"]!, direction: .right)
        UIView.translateImage(with: imageView, to: UIImage(imageLiteralResourceName: "product image"), direction: .right)
        showRightArrow()
        case 2:
        UIView.translateAndChangeLabelText(with: titleOnboarding, text: "THỐNG KÊ TRỰC QUAN", direction: .right)
        
        UIView.translateAndChangeLabelText(with: descriptionOnboarding, text: text["THỐNG KÊ TRỰC QUAN"]!, direction: .right)
        UIView.translateImage(with: imageView, to: UIImage(imageLiteralResourceName: "chart"), direction: .right)
        case 1:
        UIView.translateAndChangeLabelText(with: titleOnboarding, text: "THEO DÕI ĐỐI THỦ", direction: .right)
        
        UIView.translateAndChangeLabelText(with: descriptionOnboarding, text: text["THEO DÕI ĐỐI THỦ"]!, direction: .right)
        UIView.translateImage(with: imageView, to: UIImage(imageLiteralResourceName: "rival"), direction: .right)
        
        default:
        UIView.translateAndChangeLabelText(with: titleOnboarding, text: "THEO DÕI GIÁ", direction: .right)
        
        UIView.translateAndChangeLabelText(with: descriptionOnboarding, text: text["THEO DÕI GIÁ"]!, direction: .right)
        UIView.translateImage(with: imageView, to: UIImage(imageLiteralResourceName: "price follow"), direction: .right)
        hideLeftArrow()
        }
    }
    
    // MARK: - Preparation
    
    private func configPositionAtBegining() {
        titleOnboarding.alpha = 0
        descriptionOnboarding.alpha = 0
        
        titleOnboarding.transform = CGAffineTransform(translationX: -500, y: 0)
        descriptionOnboarding.transform = CGAffineTransform(translationX: -500, y: 0)
        
        backButton.isHidden = true
        backButton.transform = CGAffineTransform(translationX: 20, y: 0)
        
        nextButton.transform = CGAffineTransform(translationX:-20, y: 0)
        nextButton.alpha = 0
        nextButton.isEnabled = false
        
        skipButton.alpha = 0
        pageControl.alpha = 0
        
    }
    
    private func hideRightArrow() {
        UIView.animatedButton(with: registerButton, delay: 0.3, x: 0, y: 0, alphaBefore: 0, alphaAfter: 1, duration: 0.5)
        UIView.animatedButton(with: loginButton, delay: 0.3, x: 0, y: 0, alphaBefore: 0, alphaAfter: 1, duration: 0.5)
        
        UIView.animatedButton(with: nextButton, x: 20, y: 0, alphaBefore: 1, alphaAfter: 0, duration: 0.4) {
            self.nextButton.transform = CGAffineTransform(translationX: -20, y: 0)
        }
    }
    
    private func hideLeftArrow() {
        UIView.animatedButton(with: backButton, x: -20, y: 0, alphaBefore: 1, alphaAfter: 0) {
            self.backButton.transform = CGAffineTransform(translationX: 20, y: 0)
        }
    }
    
    private func showRightArrow() {
        UIView.animatedButton(with: registerButton, x: 0, y: 50, alphaBefore: 1, alphaAfter: 0, duration: 0.3)
        UIView.animatedButton(with: loginButton,x: 0, y: 50, alphaBefore: 1, alphaAfter: 0, duration: 0.3)
        UIView.animatedButton(with: nextButton, x: 0, y: 0, alphaBefore: 0, alphaAfter: 1, duration: 0.4)
    }
    
    private func showLeftArrow() {
        UIView.animatedButton(with: nextButton, x: 0, y: 0, alphaBefore: 1, alphaAfter: 1, duration: 0.4)
        backButton.isHidden = true
        if backButton.isHidden {
            UIView.animatedButton(with: backButton, x: 0, y: 0, alphaBefore: 0, alphaAfter: 1, duration: 0.4)
            backButton.isHidden = false
        }
    }
}
