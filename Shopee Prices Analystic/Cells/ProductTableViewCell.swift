//
//  ProductTableViewCell.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 7/23/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Cosmos
import SkeletonView

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCode: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var cosmos: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productPrice.showAnimatedSkeleton()
        productName.showAnimatedSkeleton()
        productImage.showAnimatedSkeleton()
        productCode.showAnimatedSkeleton()
        cosmos.showAnimatedSkeleton()
        
        cosmos.layer.cornerRadius = 4
        containerView.setShadow()
        
        selectionStyle = .none
        
        backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideSkeletonAnimation() {
        productPrice.hideSkeleton()
        productName.hideSkeleton()
        productImage.hideSkeleton()
        productCode.hideSkeleton()
        cosmos.hideSkeleton()
    }

}
