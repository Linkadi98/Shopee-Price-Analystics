//
//  Equatable+Extension.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 11/28/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import Foundation

protocol Type {
    func equalTo(_ other: Type) -> Bool
}

extension Type where Self: Equatable {
    func equalTo(_ other: Type) -> Bool {
        if let o = other as? Self { return self == o }
        return false
    }
}

extension Equatable {
    
    /// Unwrap variale which has type Any
    /// Mirror reflection does not work with optional value type but work with none-optional type
    /// Therefore if properties are optional or some of them are optional, the value of them will be unwrapped
    /// - Parameter any: value of type Any, it's explicit value can be optional or not
    private static func unwrap(_ any: Any) -> Any {
        
        let mirror = Mirror(reflecting: any)
        if mirror.displayStyle != .optional {
            return any
        }
        
        if mirror.children.isEmpty { return NSNull() }
        let (_, value) = mirror.children.first!
        return value
    }
    
    public static func compare<T>(lhs: T, rhs: T) -> Bool where T: Equatable {
        let mirrorLeft = Mirror(reflecting: lhs)
        let mirrorRight = Mirror(reflecting: rhs)
        
        let sequence1 = mirrorLeft.children.filter { $0.label != nil }
        let sequence2 = mirrorRight.children.filter { $0.label != nil }
        
        let result = zip(sequence1, sequence2).map {
            (unwrap($0.0.value) as! Type).equalTo((unwrap($0.1.value) as! Type))
        }
        return result.allSatisfy({ $0 == true })
    }
}

// MARK: Conform type which is appeared in Struct to `Type` protocol to compare between structs which have to conform Equatable

extension Int: Type {}
extension String: Type {}
extension Double: Type {}
extension Shop: Type {}

extension Array: Type where Element: Type {
    func equalTo(_ other: Type) -> Bool {
        if other is Array {
            let array = other as! [Any]
            let result = zip(self, array).map {
                $0.0.equalTo($0.1 as! Type)
            }
            return result.allSatisfy({$0 == true})
        }
        return false
    }
}
