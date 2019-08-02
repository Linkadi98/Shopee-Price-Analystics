//
//  TestViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/2/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        container.bottomAnchor.constraint(equalTo: (tabBarController?.tabBar.bottomAnchor)!).isActive = true
        // Do any additional setup after loading the view.
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
