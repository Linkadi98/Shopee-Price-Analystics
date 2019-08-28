//
//  ChosenRivalCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/22/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Cosmos

class ChosenRivalCell: UITableViewCell{

    // MARK: - Properties
    
    var delegate: ChosenRivalDelegate?
    var row = 0
    var section = 0
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView! {
        didSet {
            productImage.layer.cornerRadius = 8
            productImage.layer.maskedCorners = [.layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var rivalName: UILabel!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var rivalShopRating: CosmosView!
    @IBOutlet weak var followStatus: UILabel!
    @IBOutlet weak var autoStatus: UIImageView! {
        didSet {
            autoStatus.layer.cornerRadius = 8
            autoStatus.layer.maskedCorners = [.layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var off = #imageLiteral(resourceName: "auto off")
    var on = #imageLiteral(resourceName: "auto")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setAutoStatusOff()
        selectionStyle = .none
        containerView.setShadow()
        rivalShopRating.settings.updateOnTouch = false
        
//        let name = NSNotification.Name(rawValue: "storeDidUpdateNotification")
//        NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(storeDidUpdate(_:)), name: name, object: nil)
        
        showSkeletionAnimation()
    }
    
    @objc private func storeDidUpdate(_ notification: Notification) {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func fillCellContent(productImage: UIImage?, productName: String?, productPrice: String?, rivalName: String?, follower: String?, rivalShopRating: Double?, followStatus: String?) {
        self.productImage.image = productImage
        self.productName.text = productName
        self.productPrice.text = productPrice
        self.rivalName.text = rivalName
        self.follower.text = follower
        self.rivalShopRating.rating = rivalShopRating!
        self.followStatus.text = followStatus
    }
    func setAutoStatusOff() {
        autoStatus.image = off
    }
    
    func setAutoStatusOn() {
        autoStatus.image = on
    }

    
    
    func showSkeletionAnimation() {
        containerView.showSkeleton()
        productName.showSkeleton()
        rivalName.showSkeleton()
        rivalShopRating.showSkeleton()
        followStatus.showSkeleton()
        follower.showSkeleton()
        productPrice.showSkeleton()
    }
    
    func hideSkeletonAnimation() {
        containerView.hideSkeleton()
        productName.hideSkeleton()
        rivalName.hideSkeleton()
        rivalShopRating.hideSkeleton()
        followStatus.hideSkeleton()
        follower.hideSkeleton()
        productPrice.hideSkeleton()
    }
    
    
    @IBAction func deleteCell(_ sender: Any) {
        delegate?.deleteRow(at: row, in: section)
    }
    
    
    
    
}
