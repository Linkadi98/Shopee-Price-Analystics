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
        "DOANH SỐ NÂNG CAO": "Nâng cao doanh thu bán hàng của bạn bằng những cập nhật kịp thời trên sàn Shopee",
        "BẮT KỊP ĐỐI THỦ CỦA BẠN": "Đăng ký hoặc đăng nhập ngay"
    ]
    
    var isFirstScreen = true
    
    let posX: CGFloat = 75
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var backButton: UIButton!  {
        didSet {
            backButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleOnboarding: UILabel!
    @IBOutlet weak var descriptionOnboarding: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configPositionAtBegining()
        
        UIView.zoomInImage(with: imageView, nextAnimation: {
            UIView.animate(withDuration: 1.2, animations: {
                self.titleOnboarding.alpha = 1
                self.titleOnboarding.transform = .identity
            }, completion: { _ in
                UIView.animate(withDuration: 1.5, animations: {
                    self.descriptionOnboarding.alpha = 1
                    self.descriptionOnboarding.transform = .identity
                })
            })
//            UIView.fadeIn(view: self.titleOnboarding)
//            UIView.fadeIn(view: self.descriptionOnboarding)
        })
        
    }
    
    // MARK: - Actions
    
    @IBAction func goToNextView(_ sender: Any) {
        UIView.changeText(of: titleOnboarding, with: "THEO DÕI ĐỐI THỦ")
        isFirstScreen = false
        if !isFirstScreen {
            UIView.animatedButton(with: nextButton, x: posX, y: 0, alphaBefore: 1, alphaAfter: 1)
            if backButton.isHidden == true {
                UIView.animatedButton(with: backButton, x: -posX, y: 0, alphaBefore: 0, alphaAfter: 1)
                backButton.isHidden = false
            }
            
        }
    }
    
    @IBAction func goBackPreviousView(_ sender: Any) {
    }
    
    
    // MARK: - Preparation
    
    private func configPositionAtBegining() {
        titleOnboarding.alpha = 0
        descriptionOnboarding.alpha = 0
        
        titleOnboarding.transform = CGAffineTransform(translationX: -500, y: 0)
        descriptionOnboarding.transform = CGAffineTransform(translationX: -500, y: 0)
        
        backButton.transform = CGAffineTransform(translationX: -posX, y: 50)
        backButton.isHidden = true
    }
}
