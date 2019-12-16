//
//  SPTCompetitorProductCellTableViewCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/24/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit


class SPTCompetitorProductCell: UITableViewCell {

    @IBOutlet weak var competitorProductName: UILabel! {
        didSet {
            competitorProductName.text = "---"
        }
    }
    @IBOutlet weak var competitorProductPrice: UILabel! {
        didSet {
            competitorProductPrice.text = "---"
        }
    }
    @IBOutlet weak var competitorName: UILabel! {
        didSet {
            competitorName.text = "---"
        }
    }
    @IBOutlet weak var followingStatus: UILabel! {
        didSet {
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

    func changeFollowingStatus(isSelectedToObserve: Bool,
                               status1: String = "Đang theo dõi",
                               status2: String = "Chưa theo dõi"
    ){
        if isSelectedToObserve {
            followingStatus.text = status1
            followingStatus.textColor = .systemBlue
        }
        else {
            followingStatus.text = status2
            followingStatus.textColor = .systemRed
        }
    }
    
    func setContent(with product: Product,
                    shop: Shop?,
                    isSelectedToObserve: Bool,
                    status1: String = "Đang theo dõi",
                    status2: String = "Chưa theo dõi"
    ){
        
        competitorProductName.text = product.name
        competitorProductPrice.text = String(describing: Int(product.price!).convertPriceToVietnameseCurrency()!)
        competitorName.text = "Shop: " + (shop?.name ?? "---")
        changeFollowingStatus(isSelectedToObserve: isSelectedToObserve, status1: status1, status2: status2)
        Network.shared.loadOnlineImage(from: URL(string: product.images![0])!, to: competitorProductImage)
    }
}
