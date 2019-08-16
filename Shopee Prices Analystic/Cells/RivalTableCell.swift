//
//  RivalTableCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/9/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Cosmos

class RivalTableCell: UITableViewCell {
    
    @IBOutlet weak var rivalName: UILabel!
    @IBOutlet weak var rivalCode: UILabel!
    @IBOutlet weak var rivalRating: CosmosView!
    @IBOutlet weak var followStatus: UILabel!
    
    
    override func awakeFromNib() {
        followStatus.layer.masksToBounds = true
        followStatus.layer.cornerRadius = 4
    }
    
    func setUnfollowStatus() {
        followStatus.backgroundColor = UIColor(red: 255/255, green: 69/255, blue: 58/255, alpha: 1)
        followStatus.text = "Chưa theo dõi"
    }
    
    func setFollowStatus() {
        followStatus.backgroundColor = UIColor(red: 0/255, green: 132/255, blue: 255/255, alpha: 1)
        followStatus.text = "Đang theo dõi"
    }
}
