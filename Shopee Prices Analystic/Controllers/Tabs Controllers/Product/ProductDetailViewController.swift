//
//  ProductDetailViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/4/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Cosmos

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var ratingInNumberStyle: UILabel!
    
    var productImageForPassing: UIImage?
    var priceForPassing: String?
    var ratingForPassing: Double?
    var ratingInNumberStyleForPassing: String?
    
    var product: Product?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }
    
    // MARK: - Update UI
    
    func updateUI() {
        price.text = priceForPassing
        guard let cosmosRating = ratingForPassing else {
            return
        }
        rating.rating = cosmosRating
        ratingInNumberStyle.text = ratingInNumberStyleForPassing
    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
