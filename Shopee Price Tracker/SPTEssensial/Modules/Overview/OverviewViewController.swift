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
    
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopId: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var numOfFollowedProductAndRivalContainer: UIView!
    
    @IBOutlet weak var followerCounts: UILabel!
    @IBOutlet weak var rating: UILabel!
    var tabsVC: UITabBarController?
    let refresher = UIRefreshControl()
    
    @IBOutlet weak var codeLb: UILabel!

    var currentShop: Shop?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabsVC = storyboard?.instantiateViewController(withIdentifier: String(describing: TabsViewController.self)) as? TabsViewController

        refresher.attributedTitle = NSAttributedString(string: "Tải lại dữ liệu")
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refresher.tintColor = UIColor.orange
//        scrollView.addSubview(refresher)
        
        
        configSubView(views: containerView1, containerView2, containerView3, containerView4)
        configButton(buttons: productTabButton, priceButton, rivalButton, accountButton)
        
        // Register to receive notification change currnent shop
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: .didChangeCurrentShop, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        // currentShop is nil
        guard self.currentShop != nil, let currentShop = UserDefaults.standard.getObjectInUserDefaults(forKey: "currentShop") as? Shop, currentShop == self.currentShop else {
            fetchDataFromServer()
            return
        }
    }
    
    private func fetchDataFromServer() {

        ShopApiService.getListShops { [unowned self] (result, listShops) in
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

            guard let currentShop = UserDefaults.standard.getObjectInUserDefaults(forKey: "currentShop") as? Shop else {
                self.currentShop = nil
                return
            }

            self.currentShop = currentShop

            print("1zd\(currentShop)")
            // Update interface
            self.shopId.text = String(describing: currentShop.shopid)
            self.shopName.text = currentShop.name
            self.followerCounts.text = "\(String(describing: currentShop.followerCount))"
            self.rating.text = "\(String(describing: currentShop.ratingStar))/5.0"
            if let image = currentShop.images {
                Network.shared.loadOnlineImage(from: URL(string: image[0])!, to: self.shopImage)
            }

            // Default image
            self.status.text = "Lượt theo dõi: \(String(describing: currentShop.followerCount))"

//            self.view.hideSkeleton()
//            self.view.stopSkeletonAnimation()
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
    
    // MARK: - Notification
    
    @objc func reloadData(_ notification: Notification) {
        fetchDataFromServer()
    }

    @objc func refresh() {
        fetchDataFromServer()
        refresher.endRefreshing()
    }
}
