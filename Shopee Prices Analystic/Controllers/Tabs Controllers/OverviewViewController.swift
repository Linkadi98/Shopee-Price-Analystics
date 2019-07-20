//
//  OverviewViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/16/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var containTableView: UIView!
    @IBOutlet var superParentView: UIView!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        subView.layer.cornerRadius = 10
        subView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "shoppingImage"))
        subView.sen
        subView.setShadow()
        
        
        superParentView.setBlurEffect()
        containTableView.setShadow()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Actions
    
    @IBAction func displayListOfShop(_ sender: Any) {
        print("Shopee list")
    }
    
    

}
