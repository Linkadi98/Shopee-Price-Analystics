//
//  RivalInfoViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/7/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import Cosmos

class RivalInfoViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var rivalCode: UILabel!
    @IBOutlet weak var rivalAddress: UILabel!
    @IBOutlet weak var goodRating: UILabel!
    @IBOutlet weak var badRating: UILabel!
    @IBOutlet weak var averageRating: UILabel!
    @IBOutlet weak var averageRatingStar: CosmosView!
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var secondContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setImageForLabels()
        containerView.setShadow()
        secondContainerView.setShadow()
        
    }
    
    // MARK: - Private Modifications
    
    private func setImageForLabels() {
        averageRating.addImage(#imageLiteral(resourceName: "average rating"), "Đánh giá trung bình")
        rivalAddress.addImage(#imageLiteral(resourceName: "address"), "Địa chỉ")
        goodRating.addImage(#imageLiteral(resourceName: "good rating"), "Đánh giá tốt")
        badRating.addImage(#imageLiteral(resourceName: "bad rating"), "Đánh giá xấu")
        rivalCode.addImage(#imageLiteral(resourceName: "code"), "Mã số")
    }

}
