//
//  UITableView.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/20/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit
import JGProgressHUD

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
    
    public func displayNoDataNotification(title: String, message: String, action: UIButton? = nil, hudError: String? = nil) {
        for row in 0...self.tableView.numberOfRows(inSection: 0) {
            self.tableView.cellForRow(at: IndexPath(row: row, section: 0))?.isHidden = true
        }

//        self.view.hideSkeleton()
//        self.view.stopSkeletonAnimation()
        let noData = UILabel()
        let description = UILabel()
        let view = UIView()
        noData.text = title
        noData.textAlignment = .center
        
        description.text = message
        description.textAlignment = .center
        description.textColor = .lightGray
        description.numberOfLines = 2
        
        let stackView = UIStackView()
        stackView.addArrangedSubview(noData)
        stackView.addArrangedSubview(description)
        
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints({ make in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.center.equalToSuperview()
        })
        
        if let action = action {
            view.addSubview(action)
            action.snp.makeConstraints { make in
                make.bottom.equalTo(stackView).inset(-50)
                make.centerX.equalToSuperview()
            }
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundView = view
        
        guard hudError != nil else { return }
        let hud = SPTProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.textLabel.text = hudError
        hud.show(in: tableView.backgroundView!)
        hud.dismiss(afterDelay: 1.5)
    }
    
    
}
