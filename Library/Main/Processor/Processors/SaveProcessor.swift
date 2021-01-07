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
    func acceptDataType(forObject object: AnyObject?) -> Bool {
        if object != nil {
            return object is String
                || object is String?
                || object is Int
                || object is Int?
                || object is Double
                || object is Double?
                || object is Float
                || object is Float?
                || object is Bool
                || object is Bool?
                || object is Date
                || object is Date?
                || object is UIImage
                || object is UIImage?
        }
        return false
    }
    func save(objects: [ObjectWrapper], withForeignKey foreignKey: String? = nil,
              withFieldNameLink fieldNameLink: String? = nil,
              completion: (()->Void)? = nil) {
        var depth: Int = objects.count
        Sundeed.shared.backgroundQueue.async {
            do {
                try Processor().createTableProcessor.createTableIfNeeded(for: objects.first)
                for object in objects {
                    if let objects = object.objects {
                        let insertStatement = StatementBuilder()
                            .insertStatement(tableName: object.tableName)
                            .add(key: Sundeed.shared.foreignKey, value: foreignKey)
                            .add(key: Sundeed.shared.fieldNameLink, value: fieldNameLink)
                        for (columnName, attribute) in objects {
                            if let attribute = attribute as? ObjectWrapper {
                                if let className = attribute.className {
                                    let subObjectPrimaryKey = attribute.objects?[Sundeed.shared.primaryKey] as? String
                                    let value = Sundeed.shared
                                        .sundeedForeignValue(tableName: className,
                                                             fieldNameLink: columnName,
                                                             subObjectPrimaryKey: subObjectPrimaryKey)
                                    insertStatement.add(key: columnName, value: value)
                                    if let primaryValue = objects[Sundeed
                                        .shared.primaryKey] as? String {
                                        depth += 1
                                        self.save(objects: [attribute],
                                                  withForeignKey: primaryValue,
                                                  withFieldNameLink: columnName,
                                                  completion: {
                                                    depth = self.completionIfNeeded(depth: depth,
                                                                                    completion: completion)
                                        })
                                    } else {
                                        completion?()
                                        throw SundeedQLiteError
                                            .primaryKeyError(tableName: attribute.tableName)
                                    }
                                }
                            } else if let attribute = attribute as? [ObjectWrapper?] {
                                if let firstAttribute = attribute.compactMap({$0}).first,
                                    let className = firstAttribute.className {
                                    if let primaryValue = objects[Sundeed
                                        .shared.primaryKey] as? String {
                                        let value = Sundeed.shared
                                            .sundeedForeignValue(tableName: className,
                                                                 fieldNameLink: columnName)
                                        insertStatement
                                            .add(key: columnName,
                                                 value: value)
                                        let wrappers = attribute.compactMap({$0})
                                        depth += 1
                                        self.save(objects: wrappers,
                                                  withForeignKey: primaryValue,
                                                  withFieldNameLink: columnName,
                                                  completion: {
                                                    depth = self.completionIfNeeded(depth: depth,
                                                                                    completion: completion)
                                        })
                                    } else {
                                        completion?()
                                        throw SundeedQLiteError
                                            .primaryKeyError(tableName: firstAttribute.tableName)
                                    }
                                } else {
                                    insertStatement.add(key: columnName, value: nil)
                                }
                            } else if let attribute = attribute as? UIImage {
                                if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                                    let objectID = "\(primaryValue)\(columnName)"
                                    let attributeValue = attribute.dataTypeValue(forObjectID: objectID)
                                    insertStatement.add(key: columnName, value: attributeValue)
                                } else {
                                    completion?()
                                    throw SundeedQLiteError.primaryKeyError(tableName: object.tableName)
                                }
                            } else if let attribute = attribute as? Date {
                                if objects[Sundeed.shared.primaryKey] as? String != nil {
                                    let attributeValue = Sundeed.shared.dateFormatter.string(from: attribute)
                                    insertStatement.add(key: columnName,
                                                        value: attributeValue)
                                } else {
                                    completion?()
                                    throw SundeedQLiteError.primaryKeyError(tableName: object.tableName)
                                }
                            } else if let attribute = attribute as? [UIImage?] {
                                let compactAttribute = attribute.compactMap({$0})
                                if compactAttribute.count > 0,
                                    let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                                    let attribute: [String] = compactAttribute
                                        .enumerated()
                                        .compactMap({
                                            let indexString = String(describing: $0)
                                            let objectID = "\(primaryValue)\(columnName)\(indexString)"
                                            return $1.dataTypeValue(forObjectID: objectID)
                                        })
                                    let attributeValue = Sundeed.shared
                                        .sundeedPrimitiveForeignValue(tableName: columnName)
                                    insertStatement.add(key: columnName, value: attributeValue)
                                    depth += 1
                                    self.saveArrayOfPrimitives(tableName: columnName,
                                                               objects: attribute,
                                                               withForeignKey: primaryValue,
                                                               completion: {
                                                                depth = self.completionIfNeeded(depth: depth, completion: completion)
                                    })
                                } else {
                                    insertStatement.add(key: columnName, value: nil)
                                }
                            } else if let attribute = attribute as? [Any] {
                                if attribute.compactMap({$0}).count > 0,
                                    self.acceptDataType(forObject: attribute.first as AnyObject) {
                                    let attributeValue = Sundeed.shared
                                        .sundeedPrimitiveForeignValue(tableName: columnName)
                                    insertStatement.add(key: columnName, value: attributeValue)
                                    if let primaryValue = objects[Sundeed.shared.primaryKey] as? String {
                                        depth += 1
                                        self.saveArrayOfPrimitives(tableName: columnName,
                                                                   objects: attribute,
                                                                   withForeignKey: primaryValue,
                                                                   completion: {
                                                                    depth = self.completionIfNeeded(depth: depth, completion: completion)
                                        })
                                    } else {
                                        completion?()
                                        throw SundeedQLiteError.primaryKeyError(tableName: object.tableName)
                                    }
                                } else {
                                    insertStatement.add(key: columnName, value: nil)
                                }
                            } else if self.acceptDataType(forObject: attribute as AnyObject) {
                                insertStatement.add(key: columnName, value: String(describing: attribute))
                            }
                        }
                        let query = insertStatement.build()
                        SundeedQLiteConnection.pool.execute(query: query, completion:
                            {
                                depth = self.completionIfNeeded(depth: depth, completion: completion)
                        })
                    }
                }
            } catch {
                completion?()
                print("\(error)")
            }
        }
    }
    func saveArrayOfPrimitives<T>(tableName: String, objects: [T?], withForeignKey foreignKey: String, completion: (()->Void)? = nil) {
        var depth: Int = objects.count
        Sundeed.shared.backgroundQueue.async {
            Processor().createTableProcessor.createTableForPrimitiveDataTypes(withTableName: tableName)
            let filter = SundeedColumn(Sundeed.shared.foreignKey) == foreignKey
            self.deleteFromDB(tableName: tableName,
                              withFilters: [filter],
                              completion: {
                                for string in objects.compactMap({$0}) {
                                    let insertStatement = StatementBuilder()
                                        .insertStatement(tableName: tableName)
                                        .add(key: Sundeed.shared.foreignKey, value: foreignKey)
                                        .add(key: Sundeed.shared.valueColumnName, value: String(describing: string))
                                        .build()
                                    SundeedQLiteConnection.pool.execute(query: insertStatement, completion: {
                                        depth = self.completionIfNeeded(depth: depth) {
                                            completion?()
                                        }
                                    })
                                }
            })
        }
    }
    func deleteFromDB(tableName: String,
                      withFilters filters: [SundeedExpression<Bool>?],
                      completion: (()->Void)? = nil) {
        let deleteStatement = StatementBuilder()
            .deleteStatement(tableName: tableName)
            .withFilters(filters)
            .build()
        SundeedQLiteConnection.pool.execute(query: deleteStatement,
                                            completion: completion)
    }
    
    private func completionIfNeeded(depth: Int, completion: (()->Void)?) -> Int {
        let depth = depth - 1
        if depth <= 0 {
            completion?()
        }
        return depth
    }
}
