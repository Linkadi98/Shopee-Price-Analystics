//
//  ContainerRivalInfoViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/24/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ContainerRivalInfoViewController: UIViewController, RivalPageDelegate {
    

    var product: Product?
    var rivalResponse: RivalsResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load in rival tab")
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rivalPageSegue" {
            if let rivalPageViewController = segue.destination as? RivalPageViewController {
                rivalPageViewController.rivalResponse = self.rivalResponse
                rivalPageViewController.product = self.product!
            }
        }
    }
    
    
    func getShopName() -> [String] {
        let data = [String]()
        return data
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
