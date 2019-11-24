//
//  SPTCompetitorProductCellTableViewCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/24/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit


class SPTCompetitorProductCell: UITableViewCell {

    @IBOutlet weak var competitorProductName: UILabel!
    @IBOutlet weak var competitorProductPrice: UILabel!
    @IBOutlet weak var competitorAddress: UILabel!
    @IBOutlet weak var followingStatus: UILabel! {
        didSet {
            followingStatus.textColor = .red
            followingStatus.text = "---"
        }
    }
    
    @IBOutlet weak var competitorProductImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func changeFollowingStatus(isSelectedToObserve: Bool) {
        if isSelectedToObserve {
            followingStatus.text = "Đang theo dõi"
            followingStatus.textColor = .systemBlue
        }
        else {
            followingStatus.text = "Chưa theo dõi"
            followingStatus.textColor = .systemRed
        }
    }
}
