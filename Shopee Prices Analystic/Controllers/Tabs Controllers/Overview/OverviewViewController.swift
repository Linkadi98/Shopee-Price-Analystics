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

//        UserDefaults.standard.removeObject(forKey: "currentShop")
    }

    override func viewWillAppear(_ animated: Bool) {
//        print(69)
//        loadFirstShop()
//        print(69)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.beginIgnoringInteractionEvents()

        let activityIndicator = initActivityIndicator()
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        getListShops { _ in
            if let currentShopData = UserDefaults.standard.data(forKey: "currentShop") {
                print(currentShopData)
                if let currentShop = try? JSONDecoder().decode(Shop.self, from: currentShopData) {
                    self.currentShop = currentShop
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                activityIndicator.stopAnimating()
                if activityIndicator.isAnimating == false {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
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
