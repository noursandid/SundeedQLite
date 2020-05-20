//
//  SundeedQLiteMap+ArrayMandatory.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/16/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

infix operator <**>
public func <**> <T: SundeedQLiter>(left: inout [T], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
            var array: [SundeedQLiter] = []
        if let values = right.currentValue as? NSArray {
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
        }
        if let array = array as? [T] {
            left = array
        }
        if (array.count == 0) && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        if let key = right.key {
            right.addColumn(attribute: left, withColumnName: key)
        }
    }
}
public func <**> <T: SundeedQLiter>(left: inout [T]?, right: SundeedQLiteMap) {
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
            if (array.count == 0) && right.isSafeToAdd {
                right.isSafeToAdd = false
            }
        }
        if (left == nil) && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        if let key = right.key {
            right.addColumn(attribute: left, withColumnName: key)
        }
    }
}
public func <**> <T: SundeedQLiter>(left: inout [T?]?, right: SundeedQLiteMap) {
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
            if (array.count == 0) && right.isSafeToAdd {
                right.isSafeToAdd = false
            }
        }
        if (left == nil) && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        if let key = right.key {
            right.addColumn(attribute: left, withColumnName: key)
        }
    }
}
public func <**> <T: SundeedQLiter>(left: inout [T?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        var array: [SundeedQLiter] = []
        if let values = right.currentValue as? NSArray {
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
                    if referencedInstance != nil {
                        let map = SundeedQLiteMap(dictionnary: value)
                        referencedInstance?.sundeedQLiterMapping(map: map)
                        array.append(referencedInstance!)
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
        if (array.count == 0) && right.isSafeToAdd {
            right.isSafeToAdd = false
        }
    } else {
        if let key = right.key {
            right.addColumn(attribute: left, withColumnName: key)
        }
    }
}
