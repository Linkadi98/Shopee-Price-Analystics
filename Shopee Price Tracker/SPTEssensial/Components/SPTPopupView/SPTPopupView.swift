//
//  SPTPopupView.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/22/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

protocol SPTPopupViewProtocol {
    func didPressOnButton() -> String
}

protocol SPTPopupViewDataSource {
    func didChoose()
}

class SPTPopupView: UIView, SPTPopupViewProtocol {

    let XIB_NAME = "SPTPopupView"
    var buttonTitle: Observable<String>!
    var delegate: SPTPopupViewButtonProtocol?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var listCompetitors: UIButton!
    
    @IBOutlet weak var observeProductPrice: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle.init(for: SPTPopupView.self)
        if let viewsToAdd = bundle.loadNibNamed(XIB_NAME, owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight,
                                            .flexibleWidth]
            contentView.layer.cornerRadius = 10
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            observeProductPrice.layer.cornerRadius = 10
            observeProductPrice.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBAction func getListCompetitors(_ sender: Any) {
        buttonTitle.value = "Cửa hàng có cùng loại sản phẩm"
        hidePopup()
    }
    
    @IBAction func observeProductPrice(_ sender: Any) {
        buttonTitle.value = "Theo dõi giá sản phẩm này"
        hidePopup()
    }
    
    func didPressOnButton() -> String {
        return buttonTitle.value
    }
    
    func hidePopup() {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 100)
        })
    }
    
    func selectedButton() {
        let title = delegate?.getSelectButton()
        
        switch title {
        case "Theo dõi giá sản phẩm này":
            observeProductPrice.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        default:
            listCompetitors.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        }
    }
}

