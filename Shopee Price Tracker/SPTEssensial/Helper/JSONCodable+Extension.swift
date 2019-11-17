//
//  JSONCodable+Extension.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/17/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

extension JSONDecoder {
    public static var shared: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}


extension JSONEncoder {
    public static var shared: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
}
