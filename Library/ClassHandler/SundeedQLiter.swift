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
    func sundeedQLiterMapping(map: SundeedQLiteMap)
    init()
}

extension SundeedQLiter {
    subscript(key: String) -> AnyObject? {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children where child.label == key {
            return child.value as AnyObject
        }
        return nil
    }
    /** retrieves the tableName of the specific object*/
    func getTableName() -> String {
        return "\(type(of: self))"
    }
    /** saves the object locally */
    public func save(withForeignKey foreignKey: String? = nil,
                     completion: (()->Void)? = nil) {
        SundeedQLite.instance.save(objects: [self], withForeignKey: foreignKey,
                                   completion: {
                                    SundeedQLite.notify(for: self, operation: .save)
                                    completion?()
        })
    }
    /** deletes the object locally */
    @discardableResult
    public func delete(completion: (()->Void)? = nil) throws -> Bool {
        let result = try SundeedQLite.instance.deleteFromDB(object: self,
                                                            completion: {
                 SundeedQLite.notify(for: self, operation: .delete)
                        completion?()
        })
        return result
    }
    /** updates the object locally */
    public func update(columns: SundeedColumn..., completion: (()->Void)? = nil) throws {
        SundeedQLite.notify(for: self, operation: .update)
        try SundeedQLite.instance.update(object: self,
                                         columns: columns,
                                         completion: completion)
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
    public static func retrieve(withFilter filter: SundeedExpression<Bool>? = nil,
                                orderBy order: SundeedColumn? = nil,
                                ascending asc: Bool = true,
                                completion: ((_ data: [Self]) -> Void)?) {
        SundeedQLite.instance.retrieve(forClass: self,
                                       withFilter: filter,
                                       orderBy: order,
                                       ascending: asc,
                                       completion: { (objects) in
                                        DispatchQueue.main.async {
                                            SundeedQLite.notify(for: objects, operation: .retrieve)
                                            completion?(objects)
                                        }
        })
    }
    /** deletes all the objects of this type locally */
    public static func delete(withFilter filters: SundeedExpression<Bool>...,
        completion: (()->Void)? = nil) {
        SundeedQLite.instance.deleteAllFromDB(forClass: self,
                                              withFilters: filters,
                                              completion: completion)
    }
    /** updates specific columns of all objects of this class, or objects with a specific criteria */
    public static func update(changes: SundeedUpdateSetStatement...,
                              withFilter filter: SundeedExpression<Bool>? = nil,
                              completion: (()->Void)? = nil) throws {
        try SundeedQLite.instance.update(forClass: self,
                                         changes: changes,
                                         withFilter: filter,
                                         completion: completion)
    }
    func toObjectWrapper() -> ObjectWrapper {
        let map = SundeedQLiteMap(fetchingColumns: true)
        sundeedQLiterMapping(map: map)
        var columns = map.columns
        for (columnName, value) in map.columns {
            if let sundeedObject = value as? SundeedQLiter {
                let map = SundeedQLiteMap(fetchingColumns: true)
                sundeedObject.sundeedQLiterMapping(map: map)
                let nestedColumns: SundeedObject = map.columns.mapValues({
                    ($0 as? SundeedQLiter)?.toObjectWrapper() ?? $0
                })
                let wrapper = ObjectWrapper(tableName: sundeedObject.getTableName(),
                                            className: "\(sundeedObject)",
                    objects: nestedColumns,
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

extension Array where Element: SundeedQLiter {
    /** saves the object locally */
    public func save(completion: (()->Void)? = nil) {
        SundeedQLite.instance.save(objects: self, completion: {
            completion?()
        })
    }
}

// Listener
extension SundeedQLiter {
    public static func onAllEvents(_ function: @escaping (_ object: Self) -> Void) -> Listener {
        return SundeedQLite.addListener(object: Self.self,
                                        function: function,
                                        operation: .any)
    }
    public static func onSaveEvents(_ function: @escaping (_ object: Self) -> Void) -> Listener {
        return SundeedQLite.addListener(object: Self.self,
                                 function: function,
                                 operation: .save)
    }
    public static func onUpdateEvents(_ function: @escaping (_ object: Self) -> Void) -> Listener {
        return SundeedQLite.addListener(object: Self.self,
                                 function: function,
                                 operation: .update)
    }
    public static func onDeleteEvents(_ function: @escaping (_ object: Self) -> Void) -> Listener {
        return SundeedQLite.addListener(object: Self.self,
                                 function: function,
                                 operation: .delete)
    }
    public static func onRetrieveEvents(_ function: @escaping (_ object: Self) -> Void) -> Listener {
        return SundeedQLite.addListener(object: Self.self,
                                 function: function,
                                 operation: .retrieve)
    }
    public func onAllEvents(_ function: @escaping (_ object: Self) -> Void) -> Listener {
        return SundeedQLite.addSpecificListener(object: self,
                                         function: function,
                                         operation: .any)
    }
    public func onSaveEvents(_ function: @escaping (_ object: Self) -> Void) -> Listener {
        return SundeedQLite.addSpecificListener(object: self,
                                         function: function,
                                         operation: .save)
    }
    public func onUpdateEvents(_ function: @escaping (_ object: Self) -> Void) -> Listener {
        return SundeedQLite.addSpecificListener(object: self,
                                         function: function,
                                         operation: .update)
    }
    public func onDeleteEvents(_ function: @escaping (_ object: Self) -> Void) -> Listener {
        return SundeedQLite.addSpecificListener(object: self,
                                         function: function,
                                         operation: .delete)
    }
    public func onRetrieveEvents(_ function: @escaping (_ object: Self) -> Void) -> Listener {
        return SundeedQLite.addSpecificListener(object: self,
                                         function: function,
                                         operation: .retrieve)
    }
}
