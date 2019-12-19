//
//  SPTObservedShopProductCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/8/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class SPTObservedShopProductCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var trackingRivalProducts: UILabel!
    @IBOutlet weak var autoPriceAdjustment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(with product: Product) {
        productName.text = product.name
        productPrice.text = Int(product.price!).convertPriceToVietnameseCurrency()
        trackingRivalProducts.text = String(describing: "Theo dõi: \(product.chosen!) sản phẩm")
        
        setAutoAdjustment(auto: product.auto ?? false)
    }
    
    func setAutoAdjustment(auto: Bool) {
        if auto {
            autoPriceAdjustment.text = "Tự động chỉnh giá"
            autoPriceAdjustment.textColor = .systemBlue
        }
        else {
            autoPriceAdjustment.text = "Không tự động chỉnh giá"
            autoPriceAdjustment.textColor = .systemRed
        }
    }
    
}
