//
//  SundeedQLiteMap.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import UIKit

public class SundeedQLiteMap {
    
    private var map:[String:Any] = [:]
    var columns:[String:AnyObject] = [:]
    var fetchingColumns:Bool = false
    fileprivate var key:String?
    var currentValue:Any?
    fileprivate var dateFormatter:DateFormatter = DateFormatter()
    fileprivate static var references:[String:[String:SundeedQLiter]] = [:]
    var primaryKey:String = ""
    var orderBy:String = ""
    var asc:Bool = true
    var isOrdered:Bool = false
    var hasPrimaryKey:Bool = false
    var isSafeToAdd:Bool = true
    public subscript(key:String)->SundeedQLiteMap{
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        self.key = key
        if map.contains(where: { (key1, value1) -> Bool in
            return key1 == key
        }){
            self.currentValue = map[key]
        }
        return self
    }
    func add(attribute:String,withObject object:Any){
        self.map[attribute] = object
    }
    func addColumn<T>(attribute:T,withColumnName columnName:String){
        self.columns[columnName] = attribute as AnyObject
    }
    init(fetchingColumns:Bool) {
        self.fetchingColumns = fetchingColumns
    }
    init(dictionnary: [String:Any]) {
        self.map = dictionnary
        self.fetchingColumns = false
    }
    fileprivate static func addReference(object:SundeedQLiter,withPrimaryKey key:String,andValue value:AnyObject,andClassName className:String){
        if SundeedQLiteMap.references[className] == nil {
            SundeedQLiteMap.references[className] = [:]
        }
        if SundeedQLiteMap.references[className]!["\(value)"] == nil {
 
            SundeedQLiteMap.references[className]!["\(value)"] = object
        }
    }
    fileprivate static func getReference(forKey key:String,andValue value:AnyObject,andClassName name:String)->SundeedQLiter?{
        if SundeedQLiteMap.references[name] == nil {
            SundeedQLiteMap.references[name] = [:]
        }
        return SundeedQLiteMap.references[name]!["\(value)"]
    }
}
infix operator <~>
public func <~> <T>(left: inout T, right: (SundeedQLiteMap,SundeedQLiteConverter)) {
    if !right.0.fetchingColumns && right.0.currentValue is String{
        left = right.1.fromString(value: right.0.currentValue as! String) as! T
    }
    else{
        right.0.addColumn(attribute: left, withColumnName: right.0.key!)
    }
}

public func <~> <T>(left: inout T?, right: (SundeedQLiteMap,SundeedQLiteConverter)) {
    if !right.0.fetchingColumns && right.0.currentValue is String{
        left = right.1.fromString(value: right.0.currentValue as! String) as? T
    }
    else{
        right.0.addColumn(attribute: left, withColumnName: right.0.key!)
    }
}
public func <~> <T>(left: inout [T], right: (SundeedQLiteMap,SundeedQLiteConverter)) {
    if !right.0.fetchingColumns, let currentValue = right.0.currentValue as? [String]{
        left = currentValue.map({ right.1.fromString(value: $0) }) as! [T]
    }
    else{
        right.0.addColumn(attribute: left, withColumnName: right.0.key!)
    }
}
public func <~> <T>(left: inout [T?], right: (SundeedQLiteMap,SundeedQLiteConverter)) {
    if !right.0.fetchingColumns, let currentValue = right.0.currentValue as? [String]{
        left = currentValue.map({ right.1.fromString(value: $0) }) as! [T]
    }
    else{
        right.0.addColumn(attribute: left, withColumnName: right.0.key!)
    }
}
public func <~> <T>(left: inout [T]?, right: (SundeedQLiteMap,SundeedQLiteConverter)) {
    if !right.0.fetchingColumns, let currentValue = right.0.currentValue as? [String]{
        left = currentValue.map({ right.1.fromString(value: $0) }) as? [T]
    }
    else{
        right.0.addColumn(attribute: left, withColumnName: right.0.key!)
    }
}
public func <~> <T:SundeedQLiter>(left: inout T, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            if let value = values.firstObject {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")

                    if referencedInstance != nil {
                        left = referencedInstance as! T
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        left = object
                    }
                    
                }
            }
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> <T:SundeedQLiter>(left: inout T?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            if let value = values.firstObject {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                    
                    if referencedInstance != nil {
                        left = referencedInstance as? T
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        left = object
                    }
                }
            }
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> <T:SundeedQLiter>(left: inout [T], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                    
                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as! [T]
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> <T:SundeedQLiter>(left: inout [T]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                    
                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as? [T]
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> <T:SundeedQLiter>(left: inout [T?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                    
                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as? [T]
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> <T:SundeedQLiter>(left: inout [T?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                    
                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as! [T]
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [String], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [String]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [String?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String?]{
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Int], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Int($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Int]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Int($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Int?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Int($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Double], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Double($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Double]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Double($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Double?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Double($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Float], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Float($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Float]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Float($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Float?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Float($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [UIImage], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [UIImage]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [UIImage?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [UIImage?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout String, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? String{
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout String?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? String{
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Int, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Int(rightValue){
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Int?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Int(rightValue){
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Date, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        
        if let rightValue = right.currentValue as? String, let value = right.dateFormatter.date(from: rightValue){
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Date?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = right.dateFormatter.date(from: rightValue){
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Date], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String]{
            left = rightValue.compactMap({right.dateFormatter.date(from: $0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Date]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String]{
            left = rightValue.compactMap({right.dateFormatter.date(from: $0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Date?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String]{
            left = rightValue.compactMap({right.dateFormatter.date(from: $0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout [Date?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? [String]{
            left = rightValue.compactMap({right.dateFormatter.date(from: $0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Double, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Double(rightValue){
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout Double?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Double(rightValue){
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <~> (left: inout UIImage?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? String {
            left = UIImage.fromDatatypeValue(filePath: value)
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}

infix operator <*>
public func <*> <T>(left: inout T, right: (SundeedQLiteMap,SundeedQLiteConverter)) {
    if !right.0.fetchingColumns && right.0.currentValue is String{
        left = right.1.fromString(value: right.0.currentValue as! String) as! T
    }
    else{
        right.0.addColumn(attribute: left, withColumnName: right.0.key!)
    }
}
public func <*> <T>(left: inout T?, right: (SundeedQLiteMap,SundeedQLiteConverter)) {
    if !right.0.fetchingColumns && right.0.currentValue is String{
        left = right.1.fromString(value: right.0.currentValue as! String) as? T
        if left == nil && right.0.isSafeToAdd{
            right.0.isSafeToAdd = false
        }
    }
    else{
        right.0.addColumn(attribute: left, withColumnName: right.0.key!)
    }
}
public func <*> <T:SundeedQLiter>(left: inout T, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            if let value = values.firstObject {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                    
                    if referencedInstance != nil {
                        left = referencedInstance as! T
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        left = object
                    }
                    
                }
            }
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> <T:SundeedQLiter>(left: inout T?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            if let value = values.firstObject {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")

                    if referencedInstance != nil {
                        left = referencedInstance as? T
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        left = object
                    }
                }
            }
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> <T:SundeedQLiter>(left: inout [T], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                    
                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as! [T]
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> <T:SundeedQLiter>(left: inout [T]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")

                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as? [T]
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> <T:SundeedQLiter>(left: inout [T?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")

                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as? [T]
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> <T:SundeedQLiter>(left: inout [T?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                    
                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as! [T]
        }
        
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout String, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? String{
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout String?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? String{
            left = value
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout Int, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Int(rightValue){
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout Int?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Int(rightValue){
            left = value
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout Date, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = right.dateFormatter.date(from: rightValue){
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout Date?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = right.dateFormatter.date(from: rightValue){
            left = value
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [String], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [String]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [String?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String?]{
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Int], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Int($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Int]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Int($0)})
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Int?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Int($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Double], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Double($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Double]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Double($0)})
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Double?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Double($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Float], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Float($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Float]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Float($0)})
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [Float?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String] {
            left = value.compactMap({Float($0)})
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [UIImage], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [UIImage]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [UIImage?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout [UIImage?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? [String]{
            left = value.compactMap({ UIImage.fromDatatypeValue(filePath: $0) })
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout Double, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Double(rightValue){
            left = value
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout Double?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let rightValue = right.currentValue as? String, let value = Double(rightValue){
            left = value
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <*> (left: inout UIImage?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let value = right.currentValue as? String {
            left = UIImage.fromDatatypeValue(filePath: value)
        }
        if left == nil && right.isSafeToAdd{
            right.isSafeToAdd = false
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
infix operator <**>
public func <**> <T:SundeedQLiter>(left: inout [T], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                    
                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as! [T]
            if (array.count == 0) && right.isSafeToAdd {
                right.isSafeToAdd = false
            }
        }
        
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <**> <T:SundeedQLiter>(left: inout [T]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")

                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
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
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <**> <T:SundeedQLiter>(left: inout [T?]?, right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")

                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
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
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}
public func <**> <T:SundeedQLiter>(left: inout [T?], right: SundeedQLiteMap) {
    if !right.fetchingColumns {
        if let values = right.currentValue as? NSArray{
            var array:[SundeedQLiter] = []
            for value in values {
                if value is [String:Any] {
                    let object = T()
                    let map = SundeedQLiteMap(dictionnary: value as! [String:Any])
                    object.sundeedQLiterMapping(map: map)
                    if !map.isSafeToAdd && right.isSafeToAdd{
                        right.isSafeToAdd = false
                    }
                    let referencedInstance = SundeedQLiteMap.getReference(forKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")

                    if referencedInstance != nil {
                        array.append(referencedInstance!)
                    }
                    else{
                        SundeedQLiteMap.addReference(object: object, withPrimaryKey: map.primaryKey, andValue: map[map.primaryKey].currentValue as AnyObject, andClassName: "\(T.self)")
                        array.append(object)
                    }
                }
            }
            left = array as! [T]
            if (array.count == 0) && right.isSafeToAdd {
                right.isSafeToAdd = false
            }
        }
    }
    else{
        right.addColumn(attribute: left, withColumnName: right.key!)
    }
}

postfix operator +
public postfix func + (left : SundeedQLiteMap) -> SundeedQLiteMap {
    assert(!left.hasPrimaryKey,"You can only have one primary key")
    left.primaryKey = left.key!
    left.hasPrimaryKey = true
    return left
}
postfix operator <<
public postfix func << (left : SundeedQLiteMap) -> SundeedQLiteMap {
    assert(!left.isOrdered,"You can only order by one column")
    left.orderBy = left.key!
    left.asc = true
    left.isOrdered = true
    return left
}

postfix operator >>
public postfix func >> (left : SundeedQLiteMap) -> SundeedQLiteMap {
    assert(!left.isOrdered,"You can only order by one column")
    left.orderBy = left.key!
    left.asc = false
    left.isOrdered = true
    return left
}


