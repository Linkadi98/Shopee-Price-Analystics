//
//  RivalPageViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/7/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Parchment

class RivalPageViewController: UIViewController, PickerNameDelegate {

    var product: Product?
    var chosenRival: (Product, Shop, Observation)?
    
    var chosenRivals: [(Product, Shop, Observation)]?
    
    weak var rivalInfoViewController: RivalInfoViewController?
    weak var rivalProductTableViewController: RivalProductTableViewController?
    weak var rivalProductLineChartViewController: RivalProductLineChartViewController?
    weak var autoChangePriceTableViewController: AutoChangePriceTableViewController?
    weak var autoUpdatePriceHistoryTableViewController: AutoUpdatePriceHistoryTableViewController?
    
    var pageViewController: FixedPagingViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        addChild(pageViewController!)
        view.addSubview((pageViewController?.view)!)
        pageViewController?.didMove(toParent: self)
        
        
        pageViewController?.view.snp.makeConstraints({(make) in
            make.edges.equalToSuperview()
        })
        
        navigationController?.navigationBar.barTintColor = .white
        
        autoChangePriceTableViewController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func viewDidAppear(_ animated: Bool) {
        update()
    }
    
    func setUpViewController() {
        
        autoChangePriceTableViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: AutoChangePriceTableViewController.self)) as? AutoChangePriceTableViewController
        rivalInfoViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: RivalInfoViewController.self)) as? RivalInfoViewController
        rivalProductLineChartViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: RivalProductLineChartViewController.self)) as? RivalProductLineChartViewController
        
        rivalProductTableViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: RivalProductTableViewController.self)) as? RivalProductTableViewController
        
        autoUpdatePriceHistoryTableViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: AutoUpdatePriceHistoryTableViewController.self)) as? AutoUpdatePriceHistoryTableViewController
        
        rivalInfoViewController?.title = "Thông tin đối thủ"
        rivalProductTableViewController?.title = "Lịch sử thay đổi giá"
        rivalProductLineChartViewController?.title = "Biểu đồ thay đổi giá"
        autoChangePriceTableViewController?.title = "Chỉnh giá tự động"
        autoUpdatePriceHistoryTableViewController?.title = "Lịch sử chỉnh giá tự động"
        
        pageViewController = FixedPagingViewController(viewControllers: [rivalInfoViewController!, rivalProductTableViewController!, rivalProductLineChartViewController!, autoChangePriceTableViewController!, autoUpdatePriceHistoryTableViewController!])
        
        pageViewController?.indicatorOptions = .visible(height: 3, zIndex: 1, spacing: .zero, insets: .zero)
        
        pageViewController?.indicatorColor = .orange
        
        pageViewController?.textColor = .gray
        pageViewController?.selectedTextColor = .black
        pageViewController?.menuBackgroundColor = .white
        pageViewController?.selectedFont = UIFont.boldSystemFont(ofSize: 16)
        pageViewController?.font = UIFont.systemFont(ofSize: 16)
        pageViewController?.menuItemSize = .sizeToFit(minWidth: 200, height: 40)
        pageViewController?.menuTransition = .scrollAlongside
    }
    
    func update() {
        guard let chosenRival = chosenRival else {
            presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
            return
        }

        let rival = chosenRival.0
        let rivalShop = chosenRival.1
        let observation = chosenRival.2

        // Rival info
        rivalInfoViewController?.fillOutInfo(avatar: rivalShop.image, follower: rivalShop.followersCount, id: rivalShop.shopId, name: rivalShop.shopName, location: rivalShop.place, goodRating: rivalShop.goodRating, badRating: rivalShop.badRating, averageRating: rivalShop.rating)

        rivalInfoViewController?.fillOutProductInfo(image: rival.image, productName: rival.name, numberOfSoldItems: rival.sold, rating: rival.rating)

        // Rival product
        rivalProductTableViewController?.rival = chosenRival.0

        // Rival line chart
        rivalProductLineChartViewController?.product = product!
        rivalProductLineChartViewController?.rival = chosenRival.0

        // Auto update history
        autoUpdatePriceHistoryTableViewController?.product = product!

        // Turn on and off auto updating
//        autoChangePriceTableViewController?.product = product!
//        autoChangePriceTableViewController?.rivalProduct = chosenRival.0
        autoChangePriceTableViewController?.observation = observation
        autoChangePriceTableViewController?.chosenRivals = chosenRivals!
    }
    
    private func getShopName() -> [String] {
        var shopNames = [String]()
        
        for rival in chosenRivals! {
            shopNames.append(rival.1.shopName)
        }
        
        return shopNames
    }
    
    // Tất cả các dữ liệu đến các view này đều phải được setup tại file này
    func addNameToPicker() -> [String] {
        return getShopName()
    }
}
