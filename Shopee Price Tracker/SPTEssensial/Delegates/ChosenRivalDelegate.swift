//
//  ChosenRivalDelegate.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 8/28/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation


protocol ChosenRivalDelegate {
    func deleteRow(at row: Int, in section: Int) -> Void
}
