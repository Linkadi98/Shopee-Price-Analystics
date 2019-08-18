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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopId: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var numOfFollowedProductAndRivalContainer: UIView!
    
    @IBOutlet weak var numberOfFollowedProducts: UILabel!
    @IBOutlet weak var numberOfFollowedRivals: UILabel!
    var tabsVC: UITabBarController?
    let refresher = UIRefreshControl()
    
    @IBOutlet weak var codeLb: UILabel! {
        didSet {
            codeLb.addImage(#imageLiteral(resourceName: "connector-0"), "Mã số cửa hàng:", offsetY: -15, x: -3)
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
        
        subView.setShadow()
        buttonContainer.setShadow()
        numOfFollowedProductAndRivalContainer.setShadow()
        
        timeLabel.text = setTime()
        
        tabsVC = storyboard?.instantiateViewController(withIdentifier: String(describing: TabsViewController.self)) as? TabsViewController

        containerView.setCornerLogo()
        buttonContainer.setCornerLogo()
        subView.setCornerLogo()
        numOfFollowedProductAndRivalContainer.setCornerLogo()

        refresher.attributedTitle = NSAttributedString(string: "Tải lại dữ liệu")
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refresher.tintColor = UIColor.orange
        scrollView.addSubview(refresher)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.startSkeletonAnimation()

        // currentShop is nil
        guard self.currentShop != nil else {
            fetchingDataFromServer()
            return
        }

        // currentShop has changed
        if let currentShopData = UserDefaults.standard.data(forKey: "currentShop"), let currentShop = try? JSONDecoder().decode(Shop.self, from: currentShopData) {
            if self.currentShop != currentShop  {
                fetchingDataFromServer()
            }
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        
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
            guard let listShops = listShops, !listShops.isEmpty else {
//                self.status.addImage(#imageLiteral(resourceName: "deactive"), "Không hoạt động", offsetY: -0.5)
//                self.view.hideSkeleton()
//                self.view.stopSkeletonAnimation()
                return
            }

            print("Ds shop 69: \(listShops)")

            if let currentShopData = UserDefaults.standard.data(forKey: "currentShop"), let currentShop = try? JSONDecoder().decode(Shop.self, from: currentShopData) {
                    self.currentShop = currentShop
                    self.status.addImage(#imageLiteral(resourceName: "active"), "Đang hoạt động", offsetY: -0.5)
            }

            self.view.hideSkeleton()
            self.view.stopSkeletonAnimation()
        }
    }
    
    // MARK: - Group button actions
    
    @IBAction func switchToProductTab(_ sender: Any) {
        tabBarController?.selectedIndex = 1
        print("button pressed")
    }
    @IBAction func switchToPriceTab(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    @IBAction func switchToRivalTab(_ sender: Any) {
        tabBarController?.selectedIndex = 3
    }
    @IBAction func switchToListShop(_ sender: Any) {
        // switch to list shop view controller - not solved
        
    }

    @objc func refresh() {
        fetchingDataFromServer()
        refresher.endRefreshing()
    }
}
