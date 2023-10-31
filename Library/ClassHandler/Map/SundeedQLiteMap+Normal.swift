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
        right.0.addColumn(attribute: attribute, withColumnName: right.0.key!)
    }
}
public func <~> <T>(left: inout T?, right: (SundeedQLiteMap, SundeedQLiteConverter)) {
    if !right.0.fetchingColumns,
        let currentValue = right.0.currentValue as? String {
        left = right.1.fromString(value: currentValue) as? T
    } else {
        let attribute = right.1.toString(value: left)
        right.0.addColumn(attribute: attribute, withColumnName: right.0.key!)
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
        right.0.addColumn(attribute: attributes, withColumnName: right.0.key!)
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
        right.0.addColumn(attribute: attributes, withColumnName: right.0.key!)
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
        right.0.addColumn(attribute: attributes, withColumnName: right.0.key!)
    }
}
public func <~> <T>(left: inout [T]?, right: (SundeedQLiteMap, SundeedQLiteConverter)) {
    if !right.0.fetchingColumns,
        let currentValue = right.0.currentValue as? [String] {
        left = currentValue.map({ right.1.fromString(value: $0) }) as? [T]
    } else {
        let attributes = left?.map({right.1.toString(value: $0)})
        right.0.addColumn(attribute: attributes, withColumnName: right.0.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
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
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [String], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [String?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [String]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [String?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String?] {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Int], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Int($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Int?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.map({Int($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Int]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Int($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Int?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.map({Int($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Double], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Double($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Double?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.map({Double($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Double]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Double($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Double?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.map({Double($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Float], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Float($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Float?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.map({Float($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Float]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Float($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Float?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.map({Float($0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [UIImage], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [UIImage]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [UIImage?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.map({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [UIImage?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.map({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Bool], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String] {
            left = rightValue.compactMap({$0 == "1"})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Bool]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String] {
            left = rightValue.compactMap({$0 == "1"})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Bool?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String] {
            left = rightValue.map({$0 == "1"})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Bool?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String] {
            left = rightValue.map({$0 == "1"})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Date], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String] {
            left = rightValue.compactMap({Sundeed.shared.dateFormatter.date(from: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Date]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String] {
            left = rightValue.compactMap({Sundeed.shared.dateFormatter.date(from: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Date?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String] {
            left = rightValue.map({Sundeed.shared.dateFormatter.date(from: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Date?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String] {
            left = rightValue.map({Sundeed.shared.dateFormatter.date(from: $0)})
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout String, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? String {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout String?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        left = right.currentValue as? String
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Int, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Int(rightValue) {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Int?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String {
            left = Int(rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Date, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String,
            let value = Sundeed.shared.dateFormatter.date(from: rightValue) {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Date?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String {
            left = Sundeed.shared.dateFormatter.date(from: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Bool, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String {
            left = rightValue == "1"
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Bool?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String {
            left = rightValue == "1"
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Double, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Double(rightValue) {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Double?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String {
            left = Double(rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Float?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String {
            left = Float(rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Float, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Float(rightValue) {
            left = value
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout UIImage?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String {
            left = UIImage.fromDatatypeValue(filePath: rightValue)
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout UIImage, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String,
            let image = UIImage.fromDatatypeValue(filePath: rightValue) {
            left = image
        }
    } else {
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
