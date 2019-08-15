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
    
    public func displayNoDataNotification(title: String, message: String) {
        self.view.hideSkeleton()
        self.view.stopSkeletonAnimation()
        let noData = UILabel()
        let description = UILabel()
        let view = UIView()
        noData.text = title
        noData.textAlignment = .center
        description.text = message
        description.textAlignment = .center
        description.textColor = .lightGray
        
        let stackView = UIStackView()
        stackView.addArrangedSubview(noData)
        stackView.addArrangedSubview(description)
        
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundView = view
    }
    
    
}
