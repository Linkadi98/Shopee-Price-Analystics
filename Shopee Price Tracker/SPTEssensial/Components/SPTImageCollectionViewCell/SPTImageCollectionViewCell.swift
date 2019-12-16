//
//  SPTImageCollectionViewCell.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/13/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class SPTImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rivalProductImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    func loadImage(with url: String) {
        Network.shared.loadOnlineImage(from: URL(string: url)!, to: rivalProductImage)
    }
}
