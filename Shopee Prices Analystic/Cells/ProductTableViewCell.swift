//
//  ProductTableViewCell.swift
//  Shopee Prices Analystic
//
//  Created by Duy Truong on 7/23/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Cosmos

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCode: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var cosmos: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
