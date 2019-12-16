//
//  RivalParrentPageViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/10/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class RivalParrentPageViewController: BasePageViewController {

    var currentShopProduct: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers(with: viewControllersFromStoryboard)
        addPageViewController()
        decoratePageViewController()
        // Do any additional setup after loading the view.
    }
    
    var viewControllersFromStoryboard: [UIViewController] {
        let listObservingRivalVC = storyboard?.instantiateViewController(withIdentifier: String(describing: ObservingRivalProductsTableViewController.self)) as! ObservingRivalProductsTableViewController
        
        let autoChangePriceHistoryVC = storyboard?.instantiateViewController(withIdentifier: String(describing: AutoUpdatePriceHistoryTableViewController.self)) as! AutoUpdatePriceHistoryTableViewController
    
        listObservingRivalVC.vm = ObservingRivalProductViewModel(rivalResponse: Observable([]), currentShopProduct: currentShopProduct)
        
        autoChangePriceHistoryVC.product = currentShopProduct
        
        listObservingRivalVC.title = "Sản phẩm tương tự"
        autoChangePriceHistoryVC.title = "Lịch sử thay đổi giá"
        return [listObservingRivalVC, autoChangePriceHistoryVC]
    }
    
    
    
}
