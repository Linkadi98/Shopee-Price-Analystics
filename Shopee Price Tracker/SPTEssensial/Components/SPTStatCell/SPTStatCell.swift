//
//  SPTStatCellTableViewCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/8/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class SPTStatCell: UITableViewCell {

    @IBOutlet weak var mediumPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}