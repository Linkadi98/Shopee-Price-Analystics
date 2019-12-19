//
//  NotificationViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/17/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    
    let NOTIFICATION_CELL = "SPTNotificationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.register(UINib(nibName: NOTIFICATION_CELL, bundle: nil), forCellReuseIdentifier: NOTIFICATION_CELL)
        notificationTableView.rowHeight = UITableView.automaticDimension
        notificationTableView.estimatedRowHeight = 120
        
//        headerView.setShadow(cornerRadius: 0, shadowRadius: 10, shadowOffset: CGSize(width: 0, height: -2))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NOTIFICATION_CELL, for: indexPath) as! SPTNotificationCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
