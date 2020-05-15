//
//  SundeedQLite.swift
//  SQLiteLibrary
//
//  Created by Nour Sandid on 12/9/18.
//  Copyright © 2018 LUMBERCODE. All rights reserved.
//

import UIKit

public class SundeedQLite {
    public static var instance:SundeedQLite = SundeedQLite()
}

// Save
extension SundeedQLite {
    func save(objects: [SundeedQLiter], withForeignKey foreignKey: String? = nil) {
        let objectWrappers: [ObjectWrapper] = objects.compactMap({$0.toObjectWrapper()})
        Processor()
        .saveProcessor
        .save(objects: objectWrappers, withForeignKey: foreignKey)
    }
}

// Update
extension SundeedQLite {
    func update(obj:Any?,columns:[SundeedColumn]){
        if let object = obj as? SundeedQLiter {
            let map = SundeedQLiteMap(fetchingColumns: true)
            object.sundeedQLiterMapping(map: map)
            if let primaryValue = map.columns[Sundeed.shared.primaryKey] as? String {
                Processor()
                    .updateProcessor
                    .update(objectWrapper: object.toObjectWrapper(),
                            columns: columns,
                            withFilters: [SundeedColumn(Sundeed.shared.primaryKey) == primaryValue])
            }
            
            
        }
    }
    
    func update(forClass sundeedClass:AnyClass,changes:[SundeedUpdateSetStatement],withFilter filters:SundeedExpression<Bool>?...) throws ->Bool{
        if let sundeed = sundeedClass as? SundeedQLiter.Type {
            let map = SundeedQLiteMap(fetchingColumns: true)
            let object = sundeed.init()
            object.sundeedQLiterMapping(map: map)
            if changes.count == 0 {
                throw SundeedQLiteError.NoChangesMade(tableName: object.getTableName())
            }
            let columns = changes.map({$0.column})
            let wrapper = object.toObjectWrapper()
            for change in changes {
                wrapper.objects?[change.column.value] = change.value
            }
            Processor()
            .updateProcessor
            .update(objectWrapper: wrapper,
                    columns: columns,
                    withFilters: filters)
            return true
        }
        return false
    }
}

// Retrieve
extension SundeedQLite {
    func retrieve(forClass sundeedClass:AnyClass,
                  withFilter filter:SundeedExpression<Bool>? = nil,
                  orderBy order:SundeedColumn? = nil,
                  ascending asc:Bool = true,
                  completion:((_ data:[SundeedQLiter])->Void)?){
        Sundeed.shared.backgroundQueue.async {
            if let sundeed = sundeedClass as? SundeedQLiter.Type {
                let map = SundeedQLiteMap(fetchingColumns: true)
                let instance = sundeed.init()
                instance.sundeedQLiterMapping(map: map)

                let dictionnariesArray = Processor()
                    .retrieveProcessor
                    .retrieve(objectWrapper: instance.toObjectWrapper(),
                              withFilter: filter,
                              subObjectHandler: self.classToObjectWrapper)
                
                var objectsArray:[SundeedQLiter] = []
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
    }
    
    private func classToObjectWrapper(_ className: String) -> ObjectWrapper? {
        if let sundeedClass = NSClassFromString(String(describing: className)),
            let sundeed = sundeedClass as? SundeedQLiter.Type {
            let map = SundeedQLiteMap(fetchingColumns: true)
            let instance = sundeed.init()
            instance.sundeedQLiterMapping(map: map)
            return instance.toObjectWrapper()
        }
        return nil
    }
    
    private func sort(_ objectsArray: inout [SundeedQLiter],
                      order: SundeedColumn?,
                      asc: Bool) {
        if let order = order, objectsArray.count > 0{
            objectsArray.sort { (object1, object2) -> Bool in
                if !asc {
                    if let obj1 = object1[order.value] as? String, let obj2 = object2[order.value] as? String {
                        return obj1 > obj2
                    } else if let obj1 = object1[order.value] as? Int, let obj2 = object2[order.value] as? Int {
                        return obj1 > obj2
                    } else if let obj1 = object1[order.value] as? Date, let obj2 = object2[order.value] as? Date {
                        return obj1 > obj2
                    }
                    return false
                } else {
                    if let obj1 = object1[order.value] as? String, let obj2 = object2[order.value] as? String {
                        return obj1 < obj2
                    } else if let obj1 = object1[order.value] as? Int, let obj2 = object2[order.value] as? Int {
                        return obj1 < obj2
                    } else if let obj1 = object1[order.value] as? Date, let obj2 = object2[order.value] as? Date {
                        return obj1 < obj2
                    }
                    return false
                }
            }
        }
    }
}

// Delete
extension SundeedQLite {
    func deleteFromDB(obj: Any?) throws -> Bool {
        if let object = obj as? SundeedQLiter {
            let map = SundeedQLiteMap(fetchingColumns: true)
            object.sundeedQLiterMapping(map: map)
            guard map.hasPrimaryKey else {
                throw SundeedQLiteError.PrimaryKeyError(tableName: object.getTableName())
            }
            if let primaryValue = map.columns[map.primaryKey] as? String {
                let filter = SundeedColumn(map.primaryKey) == primaryValue
                Processor()
                .saveProcessor
                .deleteFromDB(tableName: object.getTableName(),
                                                withFilters: [filter])
                return true
            }
        }
        return false
    }
    
    func deleteAllFromDB(forClass sundeedClass:AnyClass, withFilters filters: [SundeedExpression<Bool>?])throws ->Bool{
        if let sundeed = sundeedClass as? SundeedQLiter.Type {
            let object = sundeed.init()
            let map = SundeedQLiteMap(fetchingColumns: true)
            object.sundeedQLiterMapping(map: map)
            Processor()
                .saveProcessor
                .deleteFromDB(tableName: object.getTableName(),
                              withFilters: filters)
            return true
        } else {
            return false
        }
    }
    
    public static func deleteDatabase(){
        Sundeed.shared.tables.removeAll()
        SundeedQLiteConnection.pool.deleteDatabase()
    }
}
