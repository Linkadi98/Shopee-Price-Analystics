//
//  Collection+Extension.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 12/6/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
