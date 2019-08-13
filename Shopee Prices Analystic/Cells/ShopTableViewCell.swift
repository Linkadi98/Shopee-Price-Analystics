//
//  ShopTableViewCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/2/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopId: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shopName.showAnimatedSkeleton()
        shopId.showAnimatedSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideSkeletonAnimation() {
        shopName.hideSkeleton()
        shopId.hideSkeleton()
    }
    

}
