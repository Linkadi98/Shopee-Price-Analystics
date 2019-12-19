//
//  RivalParrentContainterViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/10/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class RivalParrentContainterViewController: UIViewController {

    var currentShopProduct: Product?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "embedSegue" == segue.identifier {
            let vc = segue.destination as! RivalParrentPageViewController
            
            vc.currentShopProduct = currentShopProduct
        }
    }

}
