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
    @IBOutlet weak var status: UILabel!
    
    
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
        timeLabel.text = setTime()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.startSkeletonAnimation()
    }


    override func viewDidAppear(_ animated: Bool) {
        if currentShop == nil {
            fetchingDataFromServer()
        }
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
    
    func fetchingDataFromServer() {
        view.hideSkeleton()
        view.showAnimatedSkeleton()

        getListShops { [unowned self] (listShops) in

            guard let _ = listShops else {
                self.status.addImage(#imageLiteral(resourceName: "deactive"), "Không hoạt động", offsetY: -0.5)
                self.view.hideSkeleton()
                self.view.stopSkeletonAnimation()
                return
            }

            if let currentShopData = UserDefaults.standard.data(forKey: "currentShop"), let currentShop = try? JSONDecoder().decode(Shop.self, from: currentShopData) {
                    self.currentShop = currentShop
                    self.status.addImage(#imageLiteral(resourceName: "active"), "Đang hoạt động", offsetY: -0.5)
            }

            self.view.hideSkeleton()
            self.view.stopSkeletonAnimation()
        }
    }
}
