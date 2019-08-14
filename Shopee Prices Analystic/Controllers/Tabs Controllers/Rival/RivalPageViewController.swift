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

    weak var rivalInfoViewController: RivalInfoViewController?
    weak var rivalProductTableViewController: RivalProductTableViewController?
    weak var rivalProductLineChartViewController: RivalProductLineChartViewController?
    
    weak var chosenProductsTableViewController: ChosenProductsTableViewController?
    
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
        
        // Do any additional setup after loading the view.
    }
    
    func setUpViewController() {
        chosenProductsTableViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: ChosenProductsTableViewController.self)) as? ChosenProductsTableViewController
//        rivalInfoViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: RivalInfoViewController.self)) as? RivalInfoViewController
        rivalProductLineChartViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: RivalProductLineChartViewController.self)) as? RivalProductLineChartViewController
        
        rivalProductTableViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: RivalProductTableViewController.self)) as? RivalProductTableViewController
        
        chosenProductsTableViewController?.title = "Sản phẩm đã chọn"
//        rivalInfoViewController?.title = "Thông tin đối thủ"
        rivalProductTableViewController?.title = "Lịch sử thay đổi giá"
        rivalProductLineChartViewController?.title = "Biểu đồ thay đổi giá"
        
        pageViewController = FixedPagingViewController(viewControllers: [chosenProductsTableViewController!, rivalProductTableViewController!, rivalProductLineChartViewController!])
        
        pageViewController?.indicatorOptions = .visible(height: 3, zIndex: 1, spacing: .zero, insets: .zero)
        
        pageViewController?.indicatorColor = .orange
        
        pageViewController?.textColor = .gray
        pageViewController?.selectedTextColor = .orange
        pageViewController?.menuBackgroundColor = .white
        
        
        
    }
}

