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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView! {
        didSet {
            productImage.layer.cornerRadius = 8
            productImage.layer.maskedCorners = [.layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var rivalName: UILabel!
    @IBOutlet weak var rivalRating: CosmosView!
    @IBOutlet weak var followStatus: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        followStatus.layer.masksToBounds = true
        followStatus.layer.cornerRadius = 4
        containerView.setShadow()
        
        selectionStyle = .none
        
        showSkeletionAnimation()
    }
    
    func setUnfollowStatus() {
        followStatus.backgroundColor = UIColor(red: 255/255, green: 69/255, blue: 58/255, alpha: 1)
        followStatus.text = "Chưa theo dõi"
    }
    
    func setFollowStatus() {
        followStatus.backgroundColor = UIColor(red: 0/255, green: 132/255, blue: 255/255, alpha: 1)
        followStatus.text = "Đang theo dõi"
    }
    
    func showSkeletionAnimation() {
        containerView.showSkeleton()
        productName.showSkeleton()
        rivalName.showSkeleton()
        rivalRating.showSkeleton()
        followStatus.showSkeleton()
        followersCount.showSkeleton()
        productPrice.showSkeleton()
    }
    
    func hideSkeletonAnimation() {
        containerView.hideSkeleton()
        productName.hideSkeleton()
        rivalName.hideSkeleton()
        rivalRating.hideSkeleton()
        followStatus.hideSkeleton()
        followersCount.hideSkeleton()
        productPrice.hideSkeleton()
    }
}
