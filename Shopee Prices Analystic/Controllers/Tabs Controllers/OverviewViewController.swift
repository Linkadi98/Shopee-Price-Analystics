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
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        subView.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // MARK: - Actions
    
    @IBAction func displayListOfShop(_ sender: Any) {
        print("Shopee list")
    }
    
    

}
