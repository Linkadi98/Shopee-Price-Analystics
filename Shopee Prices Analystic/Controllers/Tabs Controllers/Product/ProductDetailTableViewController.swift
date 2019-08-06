//
//  ProductDetailTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/5/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Cosmos

class ProductDetailTableViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productCode: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var numOfSoldItem: UILabel!
    @IBOutlet weak var inventoryItem: UILabel!
    
    @IBOutlet weak var fiveStar: CosmosView!
    @IBOutlet weak var fourStar: CosmosView!
    @IBOutlet weak var threeStar: CosmosView!
    @IBOutlet weak var twoStar: CosmosView!
    @IBOutlet weak var oneStar: CosmosView!
    
    @IBOutlet weak var soldPrice: UILabel!
    @IBOutlet weak var maxPrice: UILabel!
    @IBOutlet weak var minPrice: UILabel!
    @IBOutlet weak var discountPercent: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func update() {
        
    }

}
