//
//  ChosenRivalsTableViewController.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/22/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

class ChosenRivalsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .none
        tableView.separatorStyle = .none
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChosenRivalCell", for: indexPath) as! ChosenRivalCell

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "rivalInfoSegue", sender: nil)
    }
 

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rivalInfoSegue" {
            
        }
    }
    

}
