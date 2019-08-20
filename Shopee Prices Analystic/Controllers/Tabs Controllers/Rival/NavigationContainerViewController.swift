//
//  NavigationContainerViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/16/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class NavigationContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage()
        navigationController?.navigationBar.shadowImage = img
//        navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openListProduct(_ sender: Any) {
        
        tabBarController?.selectedIndex = 1
        
        for controller in (navigationController?.viewControllers)! {
            if controller.isKind(of: ProductsTableViewController.self) {
                navigationController?.popToViewController(controller, animated: false)
                break
            }
        }
        
        
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
