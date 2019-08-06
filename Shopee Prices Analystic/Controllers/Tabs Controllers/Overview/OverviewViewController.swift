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
            backgroundImage.image = #imageLiteral(resourceName: "shoppingImage")
            backgroundImage.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopId: UILabel!
    @IBOutlet weak var timeLabel: MarqueeLabel!
    @IBOutlet var superParentView: UIView!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

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

        subView.layer.cornerRadius = 10
        subView.setShadow()
        superParentView.setBlurEffect()
        
        timeLabel.text = setTime()
        descriptionView.setShadow()

        UserDefaults.standard.removeObject(forKey: "currentShop")
    }

    override func viewWillAppear(_ animated: Bool) {
        print(69)
        loadFirstShop()
        print(69)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Thông báo cho khách hàng biết chưa có kết nối đến cửa hàng nào
        // Xử lý thông báo trước khi thông báo hiện ra bằng cách check cửa hàng đã kết nối từ api trả về
        // Xem phần định nghĩa hàm trong file EUIViewController.swift
//        notification(title: "Bạn chưa kết nối đến cửa hàng nào", style: .warning) {
//            self.statusNotification(title: "Kết nối thành công", style: .success)
//        }
    }
    
    // MARK: - Actions
    
       
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
    func loadFirstShop() {
        self.getListShops { (listShops) in
            if listShops.isEmpty {
                UserDefaults.standard.removeObject(forKey: "currentShop")
                let banner = FloatingNotificationBanner(title: "Chưa kết nối đến cửa hàng nào",
                                                        subtitle: "Bấm vào đây để kết nối",
                                                        style: .warning)
                banner.onTap = {
                    self.tabBarController?.selectedIndex = 4
                }
                banner.show(queuePosition: .back,
                            bannerPosition: .top,
                            cornerRadius: 10)
                // currentShop is nil
            } else {
                // Case: didn't save currentShop before
                guard let savedCurrentShopData = UserDefaults.standard.data(forKey: "currentShop") else {
                    self.currentShop = listShops[0]
                    if let encoded = try? JSONEncoder().encode(listShops[0]) {
                        UserDefaults.standard.set(encoded, forKey: "currentShop")
                    }
                    return
                }

                // Case: save currentShop before
                // Decode
                let savedCurrentShop = try! JSONDecoder().decode(Shop.self, from: savedCurrentShopData)

                // Check if listShop contains savedCurrentShop
                // if listShop contains savedCurrentShop, currentShop isn't changed
                if listShops.contains(savedCurrentShop) { return }

                // listShop doesn't contain savedCurrentShop
                for shop in listShops {
                    // but maybe shop was changed its name (not deleted)
                    if savedCurrentShop.shopId == shop.shopId {
                        self.currentShop = shop
                        return
                    }
                }
            }
        }
    }
}
