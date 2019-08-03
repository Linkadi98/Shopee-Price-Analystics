//
//  UITableView.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/20/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

extension UITableViewController {
    
    public func setupSearchController(for searchController: UISearchController, placeholder: String) {
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = placeholder
    }
    
    public func isEmptySearchBar(_ searchController: UISearchController) -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    public func filterContentForSearchText(_ searchText: String, filter: (String) -> Void) {
        filter(searchText)
        tableView.reloadData()
    }
    
    public func isFiltering(_ searchController: UISearchController) -> Bool {
        return searchController.isActive && !isEmptySearchBar(searchController)
    }
}
