//
//  SundeedSaveProcessor.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/11/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import UIKit

class SaveProcessor {
    /** Checks if the object is of an acceptable type */
    private func acceptDataType(forObject object:AnyObject?)->Bool{
        if object != nil {
            return object is String || object is String? || object is Int || object is Int? || object is Double || object is Double? || object is Float || object is Float? || object is Bool || object is Bool? || object is Date || object is Date? || object is UIImage || object is UIImage?
        }
        return false
    }
    
    func save(objects: [ObjectWrapper], withForeignKey foreignKey: String? = nil) {
        Sundeed.shared.backgroundQueue.async {
            do {
                try Processor().createTableProcessor.createTableIfNeeded(for: objects.first)
                for object in objects {
                    if let tableName = object.tableName,
                        let objects = object.objects {
                        let insertStatement = StatementBuilder()
                            .insertStatement(tableName: tableName)
                            .add(key: Sundeed.shared.foreignKey, value: foreignKey)
                        for (columnName,attribute) in objects {
                            if let attribute = attribute as? ObjectWrapper {
                                if let attributeObjects = attribute.objects,
                                    let foreignValue = attributeObjects[Sundeed.shared.primaryKey] as? String,
                                    let tableName = attribute.tableName,
                                    let className = attribute.className {
                                    let value = Sundeed.shared
                                        .sundeedForeignValue(tableName: className,
                                                             foreignKey: foreignValue)
                                    insertStatement.add(key: columnName, value: value)
                                    if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                                        self.save(objects: [attribute],
                                                  withForeignKey: primaryValue)
                                    } else {
                                        throw SundeedQLiteError.PrimaryKeyError(tableName: tableName)
                                    }
                                }
                                
                            } else if let attribute = attribute as? [ObjectWrapper?] {
                                if let firstAttribute = attribute.compactMap({$0}).first,
                                    let tableName = firstAttribute.tableName,
                                    let className = firstAttribute.className {
                                    insertStatement
                                        .add(key: columnName, value: Sundeed.shared
                                            .sundeedForeignValue(tableName: className))
                                    if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                                        let wrappers = attribute.compactMap({$0})
                                        self.save(objects: wrappers,
                                                  withForeignKey: primaryValue)
                                    } else {
                                        throw SundeedQLiteError.PrimaryKeyError(tableName: tableName)
                                    }
                                } else {
                                    insertStatement.add(key: columnName, value: nil)
                                }
                            } else if let attribute = attribute as? UIImage {
                                if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                                    let attributeValue = attribute.dataTypeValue(forObjectID: primaryValue)
                                    insertStatement.add(key: columnName, value: attributeValue)
                                } else {
                                    throw SundeedQLiteError.PrimaryKeyError(tableName: tableName)
                                }
                            } else if let attribute = attribute as? Date {
                                if objects[Sundeed.shared.primaryKey] as? String != nil {
                                    let attributeValue = Sundeed.shared.dateFormatter.string(from:attribute)
                                    insertStatement.add(key: columnName,
                                                        value: attributeValue)
                                } else {
                                    throw SundeedQLiteError.PrimaryKeyError(tableName: tableName)
                                }
                            } else if let attribute = attribute as? [UIImage?]{
                                if attribute.compactMap({$0}).count > 0,
                                    let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                                    let attribute = attribute.compactMap({$0?.dataTypeValue(forObjectID: "\(primaryValue)\(columnName)\(String(describing: attribute.compactMap({$0}).firstIndex(of: $0)!))")})
                                    let attributeValue = Sundeed.shared
                                        .sundeedPrimitiveForeignValue(tableName: columnName)
                                    insertStatement.add(key: columnName, value: attributeValue)
                                    self.saveArrayOfPrimitives(tableName: columnName,
                                                               objects: attribute,
                                                               withForeignKey: primaryValue)
                                } else {
                                    insertStatement.add(key: columnName, value: nil)
                                }
                            } else if let attribute = attribute as? Array<Any> {
                                if attribute.compactMap({$0}).count > 0,
                                    self.acceptDataType(forObject: attribute.first as AnyObject) {
                                    let attributeValue = Sundeed.shared
                                        .sundeedPrimitiveForeignValue(tableName: columnName)
                                    insertStatement.add(key: columnName, value: attributeValue)
                                    if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                                        self.saveArrayOfPrimitives(tableName: columnName,
                                                                   objects: attribute,
                                                                   withForeignKey: primaryValue)
                                    } else {
                                        throw SundeedQLiteError.PrimaryKeyError(tableName: tableName)
                                    }
                                } else {
                                    insertStatement.add(key: columnName, value: nil)
                                }
                            } else if self.acceptDataType(forObject: attribute as AnyObject){
                                insertStatement.add(key: columnName, value: String(describing: attribute))
                            }
                        }
                        let query = insertStatement.build()
                        SundeedQLiteConnection.pool.execute(query: query)
                    }
                }
            } catch {}
        }
    }
    
    func saveArrayOfPrimitives<T>(tableName: String, objects:[T?],withForeignKey foreignKey:String){
        Sundeed.shared.backgroundQueue.async {
            Processor().createTableProcessor.createTableForPrimitiveDataTypes(withTableName: tableName)
            let filter = SundeedColumn(Sundeed.shared.foreignKey) == foreignKey
            self.deleteFromDB(tableName: tableName,
                                   withFilters: [filter])
            for string in objects.compactMap({$0}) {
                let insertStatement = StatementBuilder()
                    .insertStatement(tableName: tableName)
                    .add(key: Sundeed.shared.foreignKey, value: foreignKey)
                    .add(key: "VALUE", value: String(describing: string))
                    .build()
                
                SundeedQLiteConnection.pool.execute(query: insertStatement)
            }
        }
    }
    
    func deleteFromDB(tableName: String,
                      withFilters filters: [SundeedExpression<Bool>?]) {
        let deleteStatement = StatementBuilder()
            .deleteStatement(tableName: tableName)
            .withFilters(filters)
            .build()
        SundeedQLiteConnection.pool.execute(query: deleteStatement)
    }
}
