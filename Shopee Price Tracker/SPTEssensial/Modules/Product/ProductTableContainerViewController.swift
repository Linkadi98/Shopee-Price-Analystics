//
//  ProductTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/22/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SnapKit

class ProductTableContainerViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var actionContainerView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    
    var vm: ProductTableContainerViewModel?
    var vm2: ProductTableViewDetailViewModel?
    
    var popup: SPTPopupView!
    var delegate: SPTPopupViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVM()
        actionContainerView.setShadow(cornerRadius: 0, shadowRadius: 1, shadowOffset: CGSize(width: 0, height: -2))
        headerView.setShadow(cornerRadius: 0, shadowRadius: 10, shadowOffset: CGSize(width: 0, height: -2))
        actionButton.layer.cornerRadius = 5
        
        configPopup()
    }
    
    @IBAction func close(_ sender: Any) {
       dismiss(animated: true)
    }
    
    @IBAction func actionOnProduct(_ sender: Any) {
        
    }
    
    @IBAction func loadMoreAction(_ sender: Any) {
        popup.isHidden = true
        popup.transform = CGAffineTransform(translationX: 0, y: 100)
        UIView.animate(withDuration: 0.25, animations: {
            self.popup.isHidden = false
            self.popup.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layer.opacity = 0.7
            if self.view.subviews.contains(self.popup) {
                self.popup.layer.opacity = 1
            }
        })
        
        
    }
    
    func configVM() {
        vm?.product?.bindAndFire { product in
            self.vm2?.product.value = product
            self.productTitle.text = product.name
        }
    }
    
    func configPopup() {
        popup = SPTPopupView()
        view.addSubview(popup)
//        view.bringSubviewToFront(popup)
        popup.snp.makeConstraints { make in
            make.bottom.equalTo(actionContainerView)
            make.trailing.equalTo(actionContainerView)
            make.leading.equalTo(actionContainerView)
            make.height.equalTo(100)
            
        }
        popup.isHidden = true
        delegate = popup
        
        // init
        popup.buttonTitle = Observable("")
        popup.buttonTitle.bind { buttonTitle in
            let title = self.delegate?.didPressOnButton()
            print(title!)
            self.actionButton.setTitle(title, for: .normal)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = "EmbededController"
        if segueId == segue.identifier {
            let vc = segue.destination as! ProductDetailTableViewController
            vc.vm = ProductTableViewDetailViewModel(product: vm!.product!)
        }
    }
}
