//
//  ListRivalProductContainerViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/5/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ListRivalProductsContainerViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    var vm: ListRivalProductsContainerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.setShadow(cornerRadius: 0, shadowRadius: 5, shadowOffset: CGSize(width: 0, height: -2))
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let embedSegue = "EmbedListRivalProductTableview"
        
        if embedSegue == segue.identifier {
            let vc = segue.destination as! ListRivalsTableViewController
            vc.vm = ListRivalsViewModel(product: vm!.product, foundRivalProducts: Observable(nil), rivalShops: Observable(nil))
        }
    }
}
