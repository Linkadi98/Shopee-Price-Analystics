//
//  BasePageViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/7/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Parchment

class BasePageViewController: UIViewController {
    
    var pageViewController: FixedPagingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpControllers(with viewControllers: [UIViewController]) {
        pageViewController = FixedPagingViewController(viewControllers: viewControllers)
    }
    
    func decoratePageViewController() {
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
    
    func setTitle(for viewController: [UIViewController], withTitles titles: [String]) {
        
        guard viewController.count == titles.count else {
            print("view controllers must have same number of titiles")
            return
        }
        
        for index in 0..<viewController.count {
            viewController[index].title = titles[index]
        }
    }
}
