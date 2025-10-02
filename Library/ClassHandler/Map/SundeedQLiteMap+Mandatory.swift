//
//  SundeedQLiteMap+Mandatory.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/16/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

// if this value does not exist, dont add the whole object
infix operator <*>
public func <*> <T>(left: inout T?, right: (SundeedQLiteMap, SundeedQLiteConverter)) {
    if !right.0.fetchingColumns && right.0.currentValue is String,
        let currentValue = right.0.currentValue as? String {
        left = right.1.fromString(value: currentValue) as? T
        if left == nil && right.0.isSafeToAdd {
            right.0.isSafeToAdd = false
        }
    } else {
        let attribute = right.1.toString(value: left)
        right.0.addColumn(attribute: attribute, withColumnName: right.0.key!, type: .text(nil))
    }
}
public func <*> <T: SundeedQLiter>(left: inout T?, right: SundeedQLiteMap) {
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
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <*> <T: SundeedQLiter>(left: inout [T]?, right: SundeedQLiteMap) {
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
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <*> <T: SundeedQLiter>(left: inout [T?]?, right: SundeedQLiteMap) {
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
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <*> (left: inout String?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? String {
            left = value
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <*> (left: inout Int?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Int(truncating: rightValue)
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <*> (left: inout Date?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(floatLiteral: rightValue.doubleValue/1000)))
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <*> (left: inout [String]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <*> (left: inout [String?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String?] {
            left = value
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <*> (left: inout [Int]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Int(truncating: $0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <*> (left: inout [Int?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Int(truncating: $0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .integer(nil))
    }
}
public func <*> (left: inout [Double]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Double(truncating: $0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <*> (left: inout [Double?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Double(truncating: $0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <*> (left: inout [Float]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Float(truncating: $0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <*> (left: inout [Float?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [NSNumber] {
            left = value.compactMap({Float(truncating: $0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .double(nil))
    }
}
public func <*> (left: inout [UIImage]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <*> (left: inout [UIImage?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!, type: .text(nil))
    }
}
public func <*> (left: inout Double?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Double(truncating: rightValue)
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        if let key = right.key {
            right.addColumn(attribute: left, withColumnName: key, type: .double(nil))
        }
    }
}

public func <*> (left: inout Float?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? NSNumber {
            left = Float(truncating: rightValue)
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        if let key = right.key {
            right.addColumn(attribute: left, withColumnName: key, type: .double(nil))
        }
    }
}
public func <*> (left: inout UIImage?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? String {
            left = UIImage.fromDatatypeValue(filePath: value)
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        if let key = right.key {
            right.addColumn(attribute: left, withColumnName: key, type: .text(nil))
        }
    }
}
