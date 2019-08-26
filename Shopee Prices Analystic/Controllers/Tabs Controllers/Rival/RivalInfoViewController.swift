//
//  RivalInfoViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/7/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Cosmos

class RivalInfoViewController: UIViewController {

    //MARK: - Properties
    var rival: Shop?
    var rivalProduct: Product?
    
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var rivalCode: UILabel!
    @IBOutlet weak var rivalAddress: UILabel!
    @IBOutlet weak var goodRating: UILabel!
    @IBOutlet weak var badRating: UILabel!
    @IBOutlet weak var averageRatingStar: CosmosView!
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var secondContainerView: UIView! 
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productSellPrice: UILabel!
    @IBOutlet weak var rating: CosmosView!
    
    @IBOutlet weak var rivalShopID: UILabel!
    @IBOutlet weak var rivalShopLocation: UILabel!
    @IBOutlet weak var rivalShopGoodRating: UILabel!
    @IBOutlet weak var rivalShopBadRating: UILabel!
    @IBOutlet weak var rivalShopAverageRating: CosmosView!
    
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var rivalShopName: UILabel!
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        setImageForLabels()
        containerView.setShadow()
        secondContainerView.setShadow()
                
    }
    
    // MARK: - Fill out information

    func fillOutInfo(avatar: String?, follower: Int, id: String, location: String?, goodRating: Int, badRating: Int, averageRating: Double) {
        if let avatar = avatar {
            loadOnlineImage(from: URL(string: avatar)!, to: self.avatar)
        }
        self.follower.text = String(follower)
        self.rivalShopID.text = id
        self.rivalShopLocation.text = location
        self.goodRating.text = String(goodRating)
        self.badRating.text = String(badRating)
        self.rivalShopAverageRating.rating = averageRating
        
    }
    
    func fillOutProductInfo(image: String, productName: String, numberOfSoldItems: Int, rating: Double) {
        loadOnlineImage(from: URL(string: image)!, to: self.productImage)
        self.productName.text = productName
        self.productSellPrice.text = String(numberOfSoldItems)
        self.rating.rating = rating
        
    }
}
