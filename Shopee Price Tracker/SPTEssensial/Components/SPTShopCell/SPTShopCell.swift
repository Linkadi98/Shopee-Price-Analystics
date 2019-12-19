//
//  SPTShopCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/15/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class SPTShopCell: UITableViewCell {

    @IBOutlet weak var shopName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(shopName: String, isCurrentShop: Bool = false) {
        self.shopName.text = shopName
        accessoryType = isCurrentShop ? .checkmark : .none
    }
}
