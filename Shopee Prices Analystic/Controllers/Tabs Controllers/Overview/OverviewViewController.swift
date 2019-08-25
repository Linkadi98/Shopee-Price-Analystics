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
    
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var containerView2: UIView!
    @IBOutlet weak var containerView3: UIView!
    @IBOutlet weak var containerView4: UIView!
    
    @IBOutlet weak var productTabButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var rivalButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopId: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var status: UILabel!
    
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

    var currentShop: Shop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        subView.setShadow()
//        numOfFollowedProductAndRivalContainer.setShadow()
        
        tabsVC = storyboard?.instantiateViewController(withIdentifier: String(describing: TabsViewController.self)) as? TabsViewController

        refresher.attributedTitle = NSAttributedString(string: "Tải lại dữ liệu")
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refresher.tintColor = UIColor.orange
//        scrollView.addSubview(refresher)
        
        
        configSubView(views: containerView1, containerView2, containerView3, containerView4)
        configButton(buttons: productTabButton, priceButton, rivalButton, accountButton)
        
        // perform tutorial view if user has not connected to any shop, redirect them to account tab
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.startSkeletonAnimation()

        // currentShop is nil
        guard self.currentShop != nil, let currentShop = getObjectInUserDefaults(forKey: "currentShop") as? Shop, currentShop == self.currentShop else {
            fetchDataFromServer()
            return
        }
    }
    
    private func fetchDataFromServer() {
        view.hideSkeleton()
        view.showAnimatedSkeleton()

        getListShops { (result, listShops) in
            guard result != .failed, let listShops = listShops else {
                return
            }

            guard !listShops.isEmpty else {
                let banner = FloatingNotificationBanner(title: "Chưa kết nối đến cửa hàng nào",
                                                        subtitle: "Bấm vào đây để kết nối",
                                                        style: .warning)
                banner.onTap = {
                    self.tabBarController?.selectedIndex = 4
                }
                banner.show(queuePosition: .back,
                            bannerPosition: .top,
                            cornerRadius: 10)
                return
            }

            guard let currentShop = self.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
                self.currentShop = nil
                return
            }

            self.currentShop = currentShop

            // Update interface
            self.shopId.text = currentShop.shopId
            self.shopName.text = currentShop.shopName
            self.status.text = "Lượt theo dõi: \(currentShop.followersCount)"

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
        tabBarController?.selectedIndex = 4
    }
    
    private func configSubView(views: UIView...) {
        for view in views {
            view.setShadow()
        }
    }
    
    private func configButton(buttons: UIButton...) {
        for button in buttons {
            button.layer.cornerRadius = 8
            button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }

    @objc func refresh() {
        fetchDataFromServer()
        refresher.endRefreshing()
    }
}
