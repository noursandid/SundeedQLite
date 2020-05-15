//
//  SundeedQLiterClasses.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import UIKit

public protocol SundeedQLiter: class {
    /** A function that describes all the mappings between database and object */
    func sundeedQLiterMapping(map:SundeedQLiteMap)
    init()
}

extension SundeedQLiter {
    subscript(key: String) -> AnyObject? {
        let m = Mirror(reflecting: self)
        for child in m.children {
            if child.label == key {
                return child.value as AnyObject
            }
        }
        return nil
    }
    /** retrieves the tableName of the specific object*/
    func getTableName()->String{
        return "\(type(of: self))"
    }
    /** saves the object locally */
    public func save(withForeignKey foreignKey:String? = nil) {
        SundeedQLite.instance.save(objects: [self],withForeignKey: foreignKey)
    }
    /** deletes the object locally */
    @discardableResult
    public func delete() throws -> Bool{
        return try SundeedQLite.instance.deleteFromDB(obj: self)
    }
    /** updates the object locally */
    public func update(columns:SundeedColumn...){
        SundeedQLite.instance.update(obj: self, columns: columns)
    }
    
    /** retrieves asynchrously all the occurences of a specific class, or add a filter
     - author:
     Nour Sandid
     - returns:
     An array of Objects of the specified class
     - Parameters:
     - filter: (Optional) add a filter to get a specific result
     * e.g: SundeedColumn("id") == "A1B2C3"
     */
    public static func retrieve(withFilter filter:SundeedExpression<Bool>? = nil,orderBy order:SundeedColumn? = nil,ascending asc:Bool = true,completion:((_ data:[Self])->Void)?) {
        SundeedQLite.instance.retrieve(forClass: self,
                                       withFilter: filter,
                                       orderBy:order,
                                       ascending: asc,
                                       completion: { (objects) in
            DispatchQueue.main.async {
                completion?(objects as! [Self])
            }
        })
    }
    /** deletes all the objects of this type locally */
    @discardableResult
    public static func delete(withFilter filters: SundeedExpression<Bool>...) throws -> Bool{
        let result = try SundeedQLite.instance.deleteAllFromDB(forClass: self,
                                                               withFilters: filters)
        return result
    }
    /** updates specific columns of all objects of this class, or objects with a specific criteria */
    public static func update(changes:SundeedUpdateSetStatement...,
        withFilter filter: SundeedExpression<Bool>? = nil) throws ->Bool{
        let result = try SundeedQLite.instance.update(forClass: self, changes: changes, withFilter: filter)
        return result
    }
    
    func toObjectWrapper() -> ObjectWrapper {
        let map = SundeedQLiteMap(fetchingColumns: true)
        sundeedQLiterMapping(map: map)
        var columns = map.columns
        for (columnName, value) in map.columns {
            if let sundeedObject = value as? SundeedQLiter {
                let map = SundeedQLiteMap(fetchingColumns: true)
                sundeedObject.sundeedQLiterMapping(map: map)
                let wrapper = ObjectWrapper(tableName: sundeedObject.getTableName(),
                                                   className: "\(sundeedObject)",
                    objects: map.columns,
                    isOrdered: map.isOrdered,
                    orderBy: map.orderBy,
                    asc: map.asc,
                    hasPrimaryKey: map.hasPrimaryKey)
                columns[columnName] = wrapper
                
            } else if let sundeedObjects = value as? [SundeedQLiter?] {
                let dictionnaries = sundeedObjects.compactMap({$0?.toObjectWrapper()})
                columns[columnName] = dictionnaries as AnyObject
            }
        }
        return ObjectWrapper(tableName: getTableName(),
                                   className: "\(self)",
                                   objects: columns,
                                   isOrdered: map.isOrdered,
                                   orderBy: map.orderBy,
                                   asc: map.asc,
                                   hasPrimaryKey: map.hasPrimaryKey)
    }
    
}

extension Array where Element : SundeedQLiter {
    /** saves the object locally */
    public func save() {
        SundeedQLite.instance.save(objects: self)
    }
}
