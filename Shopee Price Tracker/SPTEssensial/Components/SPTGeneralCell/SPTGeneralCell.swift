//
//  SPTGeneralCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/15/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class SPTGeneralCell: UITableViewCell {

    @IBOutlet weak var label: UILabel! {
        didSet {
            label.text = "---"
        }
    }
    @IBOutlet weak var value: UILabel!  {
        didSet {
            value.text = "---"
        }
    }
    @IBOutlet weak var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(label: String, value: Int, image: UIImage) {
        self.label.text = label
        self.value.text = value != -1 ? "\(value)" : "---"
        imageCell.image = image
    }
}
