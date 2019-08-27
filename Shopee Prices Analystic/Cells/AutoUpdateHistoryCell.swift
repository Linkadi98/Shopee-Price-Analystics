//
//  AutoUpdateHistoryCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/27/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class AutoUpdateHistoryCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var newPrice: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var rivalName: UILabel!
    @IBOutlet weak var differentPrice: UILabel!
    @IBOutlet weak var priceChangeStatus: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Modifications
    
    func increasePriceImage() {
        priceChangeStatus.image = #imageLiteral(resourceName: "arrow up")
    }
    
    func decreasePriceImage() {
        priceChangeStatus.image = #imageLiteral(resourceName: "arrow down")
    }
    
    

}
