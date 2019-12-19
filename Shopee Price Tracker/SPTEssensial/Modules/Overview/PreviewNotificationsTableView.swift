//
//  PreviewNotificationsTableView.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/18/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class PreviewNotificationsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let NOTIFICATION_CELL = "SPTNotificationCell"
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
        layer.cornerRadius = 5
        layer.masksToBounds = false
        setShadow()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        register(UINib(nibName: NOTIFICATION_CELL, bundle: nil), forCellReuseIdentifier: NOTIFICATION_CELL)
        let cell = tableView.dequeueReusableCell(withIdentifier: NOTIFICATION_CELL, for: indexPath) as! SPTNotificationCell
        return cell
    }
    
    
}
