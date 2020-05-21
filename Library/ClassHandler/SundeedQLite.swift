//
//  SundeedQLite.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import UIKit
public enum Operation {
    case any
    case retrieve
    case save
    case update
    case delete
}
public class Listener: Equatable {
    internal var id = UUID()
    internal var object: Any?
    internal var function: (_ object: Any) -> Void
    internal var operation: Operation
    internal var specific: Bool
    internal init(object: Any?,
         function: @escaping (_ object: Any) -> Void,
         operation: Operation,
         specific: Bool) {
        self.object = object
        self.function = function
        self.operation = operation
        self.specific = specific
    }
    
    public func stop() {
        SundeedQLite.removeListener(listener: self)
    }
    
    
    public static func == (lhs: Listener, rhs: Listener) -> Bool {
        lhs.id == rhs.id
    }
}

public class SundeedQLite {
    public static var instance: SundeedQLite = SundeedQLite()
    private static var listeners: [Listener] = []
    static func addListener<T>(object: Any?,
                               function: @escaping (_ object: T) -> Void,
                               operation: Operation) -> Listener {
        let functionWrapper: (_ object: Any) -> Void = { object in
            guard let object = object as? T else { return }
            function(object)
        }
        let listener = Listener(object: object,
                                function: functionWrapper,
                                operation: operation,
                                specific: false)
        listeners.append(listener)
        return listener
    }
    static func addSpecificListener<T>(object: Any?,
                                       function: @escaping (_ object: T) -> Void,
                                       operation: Operation) -> Listener {
        let functionWrapper: (_ object: Any) -> Void = { object in
            guard let object = object as? T else { return }
            function(object)
        }
        let listener = Listener(object: object,
                                function: functionWrapper,
                                operation: operation,
                                specific: true)
        listeners.append(listener)
        return listener
    }
    static func notify<T: SundeedQLiter>(for object: T,
                                         operation: Operation) {
        listeners.filter({
            if $0.specific {
                if let listenerObject = $0.object as? SundeedQLiter {
                    let map = SundeedQLiteMap(fetchingColumns: true)
                    object.sundeedQLiterMapping(map: map)
                    if let primaryValue = map.columns[map.primaryKey] as? String {
                        let map = SundeedQLiteMap(fetchingColumns: true)
                        listenerObject.sundeedQLiterMapping(map: map)
                        if let listenerPrimaryValue = map.columns[map.primaryKey] as? String {
                            return primaryValue == listenerPrimaryValue
                                && ($0.operation == operation || $0.operation == .any)
                        }
                    }
                }
                return false
            } else {
                return ($0.object is T.Type || $0.object == nil)
                    && ($0.operation == operation || $0.operation == .any)
            }
        }).forEach({
            $0.function(object)
        })
    }
    static func notify<T: SundeedQLiter>(for objects: [T],
                                         operation: Operation) {
        objects.forEach({notify(for: $0, operation: operation)})
    }
    
    static func removeListener(listener: Listener) {
        listeners.removeAll { (listenerInstance) -> Bool in
            return listener == listenerInstance
        }
    }
}

// Save
extension SundeedQLite {
    func save(objects: [SundeedQLiter], withForeignKey foreignKey: String? = nil,
              completion: (()->Void)?) {
        let objectWrappers: [ObjectWrapper] = objects.compactMap({$0.toObjectWrapper()})
        Processor()
            .saveProcessor
            .save(objects: objectWrappers, withForeignKey: foreignKey, completion: {
                completion?()
            })
    }
}

// Update
extension SundeedQLite {
    func update<T: SundeedQLiter>(object: T, columns: [SundeedColumn],
                                  completion: (() -> Void)?) throws {
        let map = SundeedQLiteMap(fetchingColumns: true)
        object.sundeedQLiterMapping(map: map)
        if let primaryValue = map.columns[Sundeed.shared.primaryKey] as? String {
            try Processor()
                .updateProcessor
                .update(objectWrapper: object.toObjectWrapper(),
                        columns: columns,
                        withFilters: [SundeedColumn(Sundeed.shared.primaryKey) == primaryValue],
                        completion: completion)
        } else {
            throw SundeedQLiteError.primaryKeyError(tableName: object.getTableName())
        }
    }
    func update<T: SundeedQLiter>(forClass sundeedClass: T.Type,
                                  changes: [SundeedUpdateSetStatement],
                                  withFilter filters: SundeedExpression<Bool>?...,
        completion: (()->Void)?) throws {
        let map = SundeedQLiteMap(fetchingColumns: true)
        let object = sundeedClass.init()
        object.sundeedQLiterMapping(map: map)
        if changes.count == 0 {
            throw SundeedQLiteError.noChangesMade(tableName: object.getTableName())
        }
        let columns = changes.map({$0.column})
        let wrapper = object.toObjectWrapper()
        for change in changes {
            wrapper.objects?[change.column.value] = change.value
        }
        try Processor()
            .updateProcessor
            .update(objectWrapper: wrapper,
                    columns: columns,
                    withFilters: filters,
                    completion: completion)
    }
}

// Retrieve
extension SundeedQLite {
    func retrieve<T: SundeedQLiter>(forClass sundeed: T.Type,
                                    withFilter filter: SundeedExpression<Bool>? = nil,
                                    orderBy order: SundeedColumn? = nil,
                                    ascending asc: Bool = true,
                                    completion: ((_ data: [T]) -> Void)?) {
        Sundeed.shared.backgroundQueue.async {
            let map = SundeedQLiteMap(fetchingColumns: true)
            let instance = sundeed.init()
            instance.sundeedQLiterMapping(map: map)
            let dictionnariesArray = Processor()
                .retrieveProcessor
                .retrieve(objectWrapper: instance.toObjectWrapper(),
                          withFilter: filter,
                          subObjectHandler: self.classToObjectWrapper)
            var objectsArray: [T] = []
            for dictionnary in dictionnariesArray {
                let object = sundeed.init()
                let map = SundeedQLiteMap(dictionnary: dictionnary)
                object.sundeedQLiterMapping(map: map)
                if map.isSafeToAdd {
                    objectsArray.append(object)
                }
            }
            self.sort(&objectsArray, order: order, asc: asc)
            completion?(objectsArray)
        }
    }
    func classToObjectWrapper(_ className: String) -> ObjectWrapper? {
        if let sundeedClass = NSClassFromString(String(describing: className)),
            let sundeed = sundeedClass as? SundeedQLiter.Type {
            let map = SundeedQLiteMap(fetchingColumns: true)
            let instance = sundeed.init()
            instance.sundeedQLiterMapping(map: map)
            return instance.toObjectWrapper()
        }
        return nil
    }
    private func sort<T: SundeedQLiter>(_ objectsArray: inout [T],
                                        order: SundeedColumn?,
                                        asc: Bool) {
        if let order = order, objectsArray.count > 0 {
            objectsArray.sort { (object1, object2) -> Bool in
                if !asc {
                    if let obj1 = object1[order.value] as? String,
                        let obj2 = object2[order.value] as? String {
                        return obj1 > obj2
                    } else if let obj1 = object1[order.value] as? Int,
                        let obj2 = object2[order.value] as? Int {
                        return obj1 > obj2
                    } else if let obj1 = object1[order.value] as? Date,
                        let obj2 = object2[order.value] as? Date {
                        return obj1 > obj2
                    }
                } else {
                    if let obj1 = object1[order.value] as? String,
                        let obj2 = object2[order.value] as? String {
                        return obj1 < obj2
                    } else if let obj1 = object1[order.value] as? Int,
                        let obj2 = object2[order.value] as? Int {
                        return obj1 < obj2
                    } else if let obj1 = object1[order.value] as? Date,
                        let obj2 = object2[order.value] as? Date {
                        return obj1 < obj2
                    }
                }
                return false
            }
        }
    }
}

// Delete
extension SundeedQLite {
    func deleteFromDB<T: SundeedQLiter>(object: T,
                                        completion: (()->Void)? = nil) throws -> Bool {
        let map = SundeedQLiteMap(fetchingColumns: true)
        object.sundeedQLiterMapping(map: map)
        guard map.hasPrimaryKey,
            let primaryValue = map.columns[map.primaryKey] as? String else {
                completion?()
                throw SundeedQLiteError
                    .primaryKeyError(tableName: object.getTableName())
        }
        let filter = SundeedColumn(map.primaryKey) == primaryValue
        Processor()
            .saveProcessor
            .deleteFromDB(tableName: object.getTableName(),
                          withFilters: [filter],
                          completion: completion)
        SundeedQLiteMap.removeReference(value: primaryValue as AnyObject,
                                        andClassName: "\(T.self)")
        return true
    }
    func deleteAllFromDB<T: SundeedQLiter>(forClass sundeedClass: T.Type,
                                           withFilters filters: [SundeedExpression<Bool>?],
                                           completion: (()->Void)? = nil) {
        let object = sundeedClass.init()
        let map = SundeedQLiteMap(fetchingColumns: true)
        object.sundeedQLiterMapping(map: map)
        Processor()
            .saveProcessor
            .deleteFromDB(tableName: object.getTableName(),
                          withFilters: filters,
                          completion: completion)
    }
    public static func deleteDatabase() {
        Sundeed.shared.tables.removeAll()
        SundeedQLiteConnection.pool.deleteDatabase()
    }
}
