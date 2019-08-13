//
//  OverviewViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/16/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import MarqueeLabel
import NotificationBannerSwift

class OverviewViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var backgroundImage: UIImageView! {
        didSet {
            backgroundImage.image = #imageLiteral(resourceName: "backgroundImage")
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopId: UILabel!
    @IBOutlet weak var subView: UIView!
    
    
    @IBOutlet weak var codeLb: UILabel! {
        didSet {
            codeLb.addImage(#imageLiteral(resourceName: "connector-0"), "Mã số cửa hàng:", offsetY: -15, x: -3)
        }
    }
    @IBOutlet weak var averageLb: UILabel! {
        didSet {
            averageLb.addImage(#imageLiteral(resourceName: "connector-r"), "Đánh giá trung bình", offsetY: -5, x: -2)
        }
    }
    
    @IBOutlet weak var descriptionView: UIView!

    var currentShop: Shop! {
        didSet {
            if currentShop != nil {
                shopId.text = currentShop.shopId
                shopName.text = currentShop.shopName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        subView.backgroundColor = .clear
//
        subView.setShadow()
//        subView.setBlurEffect()
        subView.layer.cornerRadius = 10
        descriptionView.setShadow()
        timeLabel.text = setTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        subView.translucent()
    }

    // MARK: - Configuration
    
    
    // MARK: - Private modifications
    private func setTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let dayOfWeek = calendar.component(.weekday, from: date)
        if(dayOfWeek == 1) {
            return "CHỦ NHẬT NGÀY \(day) THÁNG \(month)"
        }
        
        return "THỨ \(dayOfWeek) NGÀY \(day) THÁNG \(month)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.beginIgnoringInteractionEvents()

        view.hideSkeleton()
        view.showAnimatedSkeleton()

        getListShops { (listShops) in
            if let currentShopData = UserDefaults.standard.data(forKey: "currentShop") {
                if let currentShop = try? JSONDecoder().decode(Shop.self, from: currentShopData) {
                    self.currentShop = currentShop
                }
            } 

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [unowned self] in
                self.view.hideSkeleton()
                self.view.stopSkeletonAnimation()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
}
