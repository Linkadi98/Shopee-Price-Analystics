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
    @IBOutlet weak var autoChangePriceSwitch: UISwitch! {
        didSet {
            autoChangePriceSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
