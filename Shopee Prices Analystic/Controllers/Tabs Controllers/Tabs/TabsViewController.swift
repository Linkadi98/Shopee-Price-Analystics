//
//  TabsViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/15/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class TabsViewController: SwipeableTabBarController {

    var a = 1
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isSwipeEnabled = false
    }
    
    func test() {
        if isSwipeEnabled {
            print("Da goi dc tab")
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
