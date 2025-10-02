//
//  SundeedQLiteMap+Normal.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/16/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

infix operator <~>
public func <~> <T>(left: inout T, right: (SundeedQLiteMap, SundeedQLiteConverter)) {
    if !right.0.fetchingColumns,
        let currentValue = right.0.currentValue as? String {
        if let value = right.1.fromString(value: currentValue) as? T {
            left = value
        }
    } else {
        let attribute = right.1.toString(value: left)
        right.0.addColumn(attribute: attribute, withColumnName: right.0.key!, type: .text(nil))
    }
}
public func <~> <T>(left: inout T?, right: (SundeedQLiteMap, SundeedQLiteConverter)) {
    if !right.0.fetchingColumns,
        let currentValue = right.0.currentValue as? String {
        left = right.1.fromString(value: currentValue) as? T
    } else {
        let attribute = right.1.toString(value: left)
        right.0.addColumn(attribute: attribute, withColumnName: right.0.key!, type: .text(nil))
    }
}
public func <~> <T>(left: inout [T], right: (SundeedQLiteMap, SundeedQLiteConverter)) {
    if !right.0.fetchingColumns,
        let currentValue = right.0.currentValue as? [String] {
        if let value = currentValue.map({ right.1.fromString(value: $0) }) as? [T] {
            left = value
        }
    } else {
        let attributes = left.map({right.1.toString(value: $0)})
        right.0.addColumn(attribute: attributes, withColumnName: right.0.key!, type: .text(nil))
    }
}
public func <~> <T>(left: inout [T?], right: (SundeedQLiteMap, SundeedQLiteConverter)) {
    if !right.0.fetchingColumns,
        let currentValue = right.0.currentValue as? [String] {
        if let value = currentValue.map({ right.1.fromString(value: $0) }) as? [T] {
            left = value
        }
    } else {
        let attributes = left.map({right.1.toString(value: $0)})
        right.0.addColumn(attribute: attributes, withColumnName: right.0.key!, type: .text(nil))
    }
}
public func <~> <T>(left: inout [T?]?, right: (SundeedQLiteMap, SundeedQLiteConverter)) {
    if !right.0.fetchingColumns,
        let currentValue = right.0.currentValue as? [String] {
        if let value = currentValue.map({ right.1.fromString(value: $0) }) as? [T] {
            left = value
        }
    } else {
        let attributes = left?.map({right.1.toString(value: $0)})
        right.0.addColumn(attribute: attributes, withColumnName: right.0.key!, type: .text(nil))
    }
}
public func <~> <T>(left: inout [T]?, right: (SundeedQLiteMap, SundeedQLiteConverter)) {
    if !right.0.fetchingColumns,
        let currentValue = right.0.currentValue as? [String] {
        left = currentValue.map({ right.1.fromString(value: $0) }) as? [T]
    } else {
        let attributes = left?.map({right.1.toString(value: $0)})
        right.0.addColumn(attribute: attributes, withColumnName: right.0.key!, type: .text(nil))
    }
}
public func <~> <T: SundeedQLiter>(left: inout T, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray {
            if let value = values.firstObject as? [String: Any] {
                let object = T()
                let map = SundeedQLiteMap(dictionnary: value)
                object.sundeedQLiterMapping(map: map)
                if !map.isSafeToAdd && right.isSafeToAdd {
                    right.isSafeToAdd = false
                }
                let referencedInstance = SundeedQLiteMap
                    .getReference(andValue: map[map.primaryKey].currentValue as AnyObject,
                                  andClassName: "\(T.self)")
                if let referencedInstance = referencedInstance as? T {
                    let map = SundeedQLiteMap(dictionnary: value)
                    referencedInstance.sundeedQLiterMapping(map: map)
                    left = referencedInstance
                } else {
                    SundeedQLiteMap.addReference(object: object,
                                                 andValue: map[map.primaryKey].currentValue as AnyObject,
                                                 andClassName: "\(T.self)")
                    left = object
                }
            }
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> <T: SundeedQLiter>(left: inout T?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray {
            if let value = values.firstObject {
                if let value = value as? [String: Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value)
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd {
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap
                        .getReference(andValue: map[map.primaryKey].currentValue as AnyObject,
                                      andClassName: "\(T.self)")
                    if referencedInstance != nil {
                        let map = SundeedQLiteMap(dictionnary: value)
                        referencedInstance?.sundeedQLiterMapping(map: map)
                        left = referencedInstance as? T
                    } else {
                        SundeedQLiteMap.addReference(object: object,
                                                     andValue: map[map.primaryKey].currentValue as AnyObject,
                                                     andClassName: "\(T.self)")
                        left = object
                    }
                }
            }
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> <T: SundeedQLiter>(left: inout [T], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray {
            var array: [SundeedQLiter] = []
            for value in values where value is [String: Any] {
                if let value = value as? [String: Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value)
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd {
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap
                        .getReference(andValue: map[map.primaryKey].currentValue as AnyObject,
                                      andClassName: "\(T.self)")
                    if let referencedInstance = referencedInstance {
                        let map = SundeedQLiteMap(dictionnary: value)
                        referencedInstance.sundeedQLiterMapping(map: map)
                        array.append(referencedInstance)
                    } else {
                        SundeedQLiteMap.addReference(object: object,
                                                     andValue: map[map.primaryKey].currentValue as AnyObject,
                                                     andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            if let array = array as? [T] {
                left = array
            }
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> <T: SundeedQLiter>(left: inout [T]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray {
            var array: [SundeedQLiter] = []
            for value in values where value is [String: Any] {
                if let value = value as? [String: Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value)
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd {
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap
                        .getReference(andValue: map[map.primaryKey].currentValue as AnyObject,
                                      andClassName: "\(T.self)")
                    if let referencedInstance = referencedInstance {
                        let map = SundeedQLiteMap(dictionnary: value)
                        referencedInstance.sundeedQLiterMapping(map: map)
                        array.append(referencedInstance)
                    } else {
                        SundeedQLiteMap.addReference(object: object,
                                                     andValue: map[map.primaryKey].currentValue as AnyObject,
                                                     andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as? [T]
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> <T: SundeedQLiter>(left: inout [T?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray {
            var array: [SundeedQLiter] = []
            for value in values where value is [String: Any] {
                if let value = value as? [String: Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value)
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd {
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap
                        .getReference(andValue: map[map.primaryKey].currentValue as AnyObject,
                                      andClassName: "\(T.self)")
                    if let referencedInstance = referencedInstance {
                        let map = SundeedQLiteMap(dictionnary: value)
                        referencedInstance.sundeedQLiterMapping(map: map)
                        array.append(referencedInstance)
                    } else {
                        SundeedQLiteMap.addReference(object: object,
                                                     andValue: map[map.primaryKey].currentValue as AnyObject,
                                                     andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as? [T]
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> <T: SundeedQLiter>(left: inout [T?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray {
            var array: [SundeedQLiter] = []
            for value in values where value is [String: Any] {
                if let value = value as? [String: Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value)
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd {
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap
                        .getReference(andValue: map[map.primaryKey].currentValue as AnyObject,
                                      andClassName: "\(T.self)")
                    if let referencedInstance = referencedInstance {
                        let map = SundeedQLiteMap(dictionnary: value)
                        referencedInstance.sundeedQLiterMapping(map: map)
                        array.append(referencedInstance)
                    } else {
                        SundeedQLiteMap.addReference(object: object,
                                                     andValue: map[map.primaryKey].currentValue as AnyObject,
                                                     andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            if let array = array as? [T] {
                left = array
            }
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout [String], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout [String?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout [String]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout [String?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String?] {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout [Int], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Int(truncating: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout [Int?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber?] {
            left = value.map({
                if let integer = $0 {
                    return Int(truncating: integer)
                }
                return nil
            })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout [Int]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Int(truncating: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout [Int?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber?] {
            left = value.map({
                if let integer = $0 {
                    return Int(truncating: integer)
                }
                return nil
            })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout [Double], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Double(truncating: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Double?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber?] {
            left = value.map({
                if let double = $0 {
                    return Double(truncating: double)
                }
                return nil
            })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Double]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Double(truncating: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Double?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber?] {
            left = value.map({
                if let double = $0 {
                    return Double(truncating: double)
                }
                return nil
            })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Float], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Float(truncating: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Float?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber?] {
            left = value.map({
                if let float = $0 {
                    return Float(truncating: float)
                }
                return nil
            })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Float]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Float(truncating: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Float?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber?] {
            left = value.map({
                if let float = $0 {
                    return Float(truncating: float)
                }
                return nil
            })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Data], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [Data] {
            left = value.compactMap({$0})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .blob(nil))
    }
}
public func <~> (left: inout [Data?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [Data] {
            left = value.map({$0})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .blob(nil))
    }
}
public func <~> (left: inout [Data]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [Data] {
            left = value.compactMap({$0})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .blob(nil))
    }
}
public func <~> (left: inout [Data?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [Data] {
            left = value.map({$0})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .blob(nil))
    }
}
public func <~> (left: inout [UIImage], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout [UIImage]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout [UIImage?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.map({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout [UIImage?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.map({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout [Bool], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [NSNumber] {
            left = rightValue.compactMap({Bool(truncating: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout [Bool]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [NSNumber] {
            left = rightValue.compactMap({Bool(truncating: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout [Bool?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [NSNumber] {
            left = rightValue.map({Bool(truncating: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout [Bool?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [NSNumber] {
            left = rightValue.map({Bool(truncating: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout [Date], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [NSNumber] {
            left = rightValue.compactMap({Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(floatLiteral: $0.doubleValue/1000)))})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Date]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [NSNumber] {
            left = rightValue.compactMap({Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(floatLiteral: $0.doubleValue/1000)))})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Date?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [NSNumber] {
            left = rightValue.map({Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(floatLiteral: $0.doubleValue/1000)))})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout [Date?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [NSNumber] {
            left = rightValue.map({Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(floatLiteral: $0.doubleValue/1000)))})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout String, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? String {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout String?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        left = right.currentValue as? String
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout Int, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Int(truncating: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout Int?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Int(truncating: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout Date, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(floatLiteral: rightValue.doubleValue/1000)))
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout Date?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(floatLiteral: rightValue.doubleValue/1000)))
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout Bool, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Bool(truncating: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout Bool?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Bool(truncating: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <~> (left: inout Double, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Double(truncating: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout Double?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Double(truncating: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout Float?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Float(truncating: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout Float, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Float(truncating: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <~> (left: inout Data?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? Data {
            left = rightValue
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .blob(nil))
    }
}
public func <~> (left: inout Data, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? Data {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .blob(nil))
    }
}
public func <~> (left: inout UIImage?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String {
            left = UIImage.fromDatatypeValue(filePath: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <~> (left: inout UIImage, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String,
            let image = UIImage.fromDatatypeValue(filePath: rightValue) {
            left = image
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
