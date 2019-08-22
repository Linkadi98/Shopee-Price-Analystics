//
//  ChosenRivalCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/22/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Cosmos

class ChosenRivalCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var rivalName: UILabel!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var rivalShopRating: CosmosView!
    @IBOutlet weak var followStatus: UILabel!
    @IBOutlet weak var autoStatus: UIImageView!
    
    var off = #imageLiteral(resourceName: "auto off")
    var on = #imageLiteral(resourceName: "auto")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillCellContent(productImage: UIImage?, productName: String?, productPrice: String?, rivalName: String?, follower: String?, rivalShopRating: Double?, followStatus: String?) {
        self.productImage.image = productImage
        self.productName.text = productName
        self.productPrice.text = productPrice
        self.rivalName.text = rivalName
        self.follower.text = follower
        self.rivalShopRating.rating = rivalShopRating!
        self.followStatus.text = followStatus
    }
    func setAutoStatusOff() {
        autoStatus.image = off
    }
    
    func setAutoStatusOn() {
        autoStatus.image = on
    }

}
