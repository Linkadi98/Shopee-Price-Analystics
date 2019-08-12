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
        
        UserDefaults.standard.removeObject(forKey: "currentShop")
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
    

}

extension OverviewViewController {
//    func loadFirstShop() {
//        self.getListShops { (listShops) in
//            if listShops.isEmpty {
//                UserDefaults.standard.removeObject(forKey: "currentShop")
//                let banner = FloatingNotificationBanner(title: "Chưa kết nối đến cửa hàng nào",
//                                                        subtitle: "Bấm vào đây để kết nối",
//                                                        style: .warning)
//                banner.onTap = {
//                    self.tabBarController?.selectedIndex = 4
//                }
//                banner.show(queuePosition: .back,
//                            bannerPosition: .top,
//                            cornerRadius: 10)
//                // currentShop is nil
//            } else {
//                // Case: didn't save currentShop before
//                guard let savedCurrentShopData = UserDefaults.standard.data(forKey: "currentShop") else {
//                    self.currentShop = listShops[0]
//                    if let encoded = try? JSONEncoder().encode(listShops[0]) {
//                        UserDefaults.standard.set(encoded, forKey: "currentShop")
//                    }
//                    return
//                }
//
//                // Case: save currentShop before
//                // Decode
//                let savedCurrentShop = try! JSONDecoder().decode(Shop.self, from: savedCurrentShopData)
//
//                // Check if listShop contains savedCurrentShop
//                // if listShop contains savedCurrentShop, currentShop isn't changed
//                if listShops.contains(savedCurrentShop) { return }
//
//                // listShop doesn't contain savedCurrentShop
//                for shop in listShops {
//                    // but maybe shop was changed its name (not deleted)
//                    if savedCurrentShop.shopId == shop.shopId {
//                        self.currentShop = shop
//                        return
//                    }
//                }
//            }
//        }
//    }
}
