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
        right.0.addColumn(attribute: attribute, withColumnName: right.0.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout Int?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Int(rightValue) {
            left = value
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout Date?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String,
            let value = Sundeed.shared.dateFormatter.date(from: rightValue) {
            left = value
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Int]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Int($0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Int?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Int($0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Double]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Double($0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Double?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Double($0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Float]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Float($0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Float?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Float($0)})
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout Double?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Double(rightValue) {
            left = value
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        if let key = right.key {
            right.addColumn(attribute: left, withColumnName: key)
        }
    }
}

public func <*> (left: inout Float?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Float(rightValue) {
            left = value
        }
        if left == nil && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        if let key = right.key {
            right.addColumn(attribute: left, withColumnName: key)
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
            right.addColumn(attribute: left, withColumnName: key)
        }
    }
}
