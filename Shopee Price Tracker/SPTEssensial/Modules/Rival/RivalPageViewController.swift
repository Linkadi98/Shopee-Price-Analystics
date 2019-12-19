//
//  RivalPageViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/7/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Parchment

class RivalPageViewController: UIViewController {

    var product: Product?
    var rivalResponse: RivalsResponse?
        
    weak var rivalProductLineChartViewController: RivalProductLineChartViewController?
    weak var autoChangePriceTableViewController: AutoChangePriceTableViewController?
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        update()
    }
    
    func setUpViewController() {
        
        autoChangePriceTableViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: AutoChangePriceTableViewController.self)) as? AutoChangePriceTableViewController
        
        rivalProductLineChartViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: RivalProductLineChartViewController.self)) as? RivalProductLineChartViewController
        
        rivalProductLineChartViewController?.title = "Biểu đồ thay đổi giá"
        autoChangePriceTableViewController?.title = "Chỉnh giá tự động"
        
        pageViewController = FixedPagingViewController(viewControllers: [ rivalProductLineChartViewController!, autoChangePriceTableViewController!])
        
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
        guard let rivalResponse = rivalResponse else {
            presentAlert(title: "Lỗi không xác định", message: "Vui lòng thử lại sau")
            return
        }

        let rival = rivalResponse.itemRival
//        let rivalShop = chosenRival.itemRival.

        // Rival line chart
        rivalProductLineChartViewController?.product = product!
        rivalProductLineChartViewController?.rivalProduct = rivalResponse.itemRival


        // Turn on and off auto updating
//        autoChangePriceTableViewController?.product = product!
//        autoChangePriceTableViewController?.rivalProduct = chosenRival.0
        autoChangePriceTableViewController?.rivalResponse = rivalResponse
    }
    
    // Tất cả các dữ liệu đến các view này đều phải được setup tại file này
}

