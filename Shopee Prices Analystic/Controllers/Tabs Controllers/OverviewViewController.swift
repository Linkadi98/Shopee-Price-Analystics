//
//  OverviewViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/16/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var welcome: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        time.center.x = view.center.x
        time.center.x -= view.bounds.width
        animationText()
    }
    
    // MARK: - Animation
    
    private func animationText() {
        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseOut, animations: {
            self.time.center.x  += self.view.bounds.width - 10
            self.view.layoutIfNeeded()
        }, completion: nil)
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
