//
//  ProductTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/22/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SnapKit

protocol SPTPopupViewButtonProtocol {
    func getSelectButton() -> String
}

class ProductTableContainerViewController: UIViewController, SPTPopupViewButtonProtocol {
    
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var actionContainerView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    
    var vm: ProductTableContainerViewModel?
    var vm2: ProductTableViewDetailViewModel?
    
    var popup: SPTPopupView!
    var delegate: SPTPopupViewProtocol?
    
    var opagueView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVM()
        actionContainerView.setShadow(cornerRadius: 0, shadowRadius: 1, shadowOffset: CGSize(width: 0, height: -2))
        headerView.setShadow(cornerRadius: 0, shadowRadius: 10, shadowOffset: CGSize(width: 0, height: -2))
        actionButton.layer.cornerRadius = 5
    }
    
    @IBAction func close(_ sender: Any) {
       dismiss(animated: true)
    }
    
    @IBAction func actionOnProduct(_ sender: Any) {
        switch actionButton.titleLabel?.text {
        case "Theo dõi giá sản phẩm này":
            vm!.observeProductPrice()
        default:
            vm!.getCompetitorsHasSameProduct()
        }
    }
    
    @IBAction func loadMoreAction(_ sender: Any) {
        showPopup()
    }
    
    // MARK: Configs
    
    func configVM() {
        vm?.product?.bindAndFire { product in
            self.vm2?.product.value = product
            self.productTitle.text = product.name
        }
    }
    
    func configPopup() {
        popup = SPTPopupView()
        view.addSubview(popup)
        popup.snp.makeConstraints { make in
            make.bottom.equalTo(actionContainerView)
            make.trailing.equalTo(actionContainerView)
            make.leading.equalTo(actionContainerView)
            make.height.equalTo(100)
            
        }
        popup.transform = CGAffineTransform(translationX: 0, y: 100)
        
        delegate = popup
        popup.delegate = self
        popup.selectedButton()
        
        // init
        popup.buttonTitle = Observable("")
        
        // binding
        popup.buttonTitle.bind { buttonTitle in
            let title = self.delegate?.didPressOnButton()
            self.actionButton.setTitle(title, for: .normal)
            
            UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                self.opagueView.backgroundColor = UIColor(white: 0.25, alpha: 0)
            }, completion: { [unowned self] _ in
                self.popup.removeFromSuperview()
                self.opagueView.removeFromSuperview()
                self.popup = nil
                self.opagueView = nil
            })
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hidePopup(_:)))
        opagueView.addGestureRecognizer(gesture)
        
    }
    
    // MARK: Handle Popup
    
    fileprivate func showPopup() {
        opagueView = UIView()
        view.addSubview(opagueView)
        opagueView.backgroundColor = UIColor(white: 0.25, alpha: 0)
        opagueView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(actionContainerView)
            make.top.equalToSuperview()
        }
        
        configPopup()
        let selected = getSelectButton()
        print(selected)
        UIView.animate(withDuration: 0.25, animations: {
            self.opagueView.backgroundColor = UIColor(white: 0.25, alpha: 0.5)
            self.popup.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    private func removeOpagueView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.opagueView.backgroundColor = UIColor(white: 0.25, alpha: 0)
            }, completion: { [unowned self] _ in
                self.opagueView.removeFromSuperview()
                self.opagueView = nil
        })
    }
    
    @objc func hidePopup(_ sender: UITapGestureRecognizer) {
        popup.hidePopup()
        removeOpagueView()
    }
    
    func getSelectButton() -> String {
        return (actionButton.titleLabel?.text)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = "EmbededController"
        if segueId == segue.identifier {
            let vc = segue.destination as! ProductDetailTableViewController
            vc.vm = ProductTableViewDetailViewModel(product: vm!.product!)
        }
    }
}
