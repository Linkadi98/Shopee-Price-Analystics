//
//  ProductViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/20/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var containerTableView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        containerTableView.layer.cornerRadius = 15
    }
}
