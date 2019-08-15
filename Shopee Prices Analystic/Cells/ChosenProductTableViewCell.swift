//
//  ChosenProductTableViewCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/14/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ChosenProductTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productId: UILabel!
    @IBOutlet weak var numberOfRival: UILabel!
    @IBOutlet weak var autoChangePriceStatus: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        autoChangePriceStatus.layer.masksToBounds = true
        autoChangePriceStatus.layer.cornerRadius = 4
        containerView.setShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
