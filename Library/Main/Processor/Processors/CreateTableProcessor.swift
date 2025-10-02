//
//  SundeedCreateTableProcessor.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/11/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class CreateTableProcessor: Processor {
    func createTableIfNeeded(for object: ObjectWrapper?) throws {
        guard let object = object,
              let objects = object.objects else {
            throw SundeedQLiteError.noObjectPassed
        }
        if !Sundeed.shared.tables.contains(object.tableName) {
            SundeedLogger.info("Creating table for \(object.tableName)")
            let createTableStatement = StatementBuilder()
                .createTableStatement(tableName: object.tableName)
            for (columnName, attribute) in objects {
                if let attribute = attribute as? ObjectWrapper {
                    try createTableIfNeeded(for: attribute)
                } else if let attribute = attribute as? [ObjectWrapper] {
                    if let firstAttribute = attribute.first {
                        try createTableIfNeeded(for: firstAttribute)
                    }
                } else if attribute is [Any] {
                    if let array = attribute as? [Any], let _ = array.first as? Data {
                        createTableForPrimitiveDataTypes(withTableName: columnName, type: .blob(nil))
                    } else if let array = attribute as? [Any], let _ = array.first as? Date {
                        createTableForPrimitiveDataTypes(withTableName: columnName, type: .double(nil))
                    } else if let array = attribute as? [Any], let attribute = array.first as? NSNumber, !CFNumberIsFloatType(attribute as CFNumber) {
                        createTableForPrimitiveDataTypes(withTableName: columnName, type: .integer(nil))
                    } else if let array = attribute as? [Any], let _ = array.first as? Double {
                        createTableForPrimitiveDataTypes(withTableName: columnName, type: .double(nil))
                    } else if let array = attribute as? [Any], let _ = array.first as? Float {
                        createTableForPrimitiveDataTypes(withTableName: columnName, type: .double(nil))
                    } else {
                        createTableForPrimitiveDataTypes(withTableName: columnName)
                    }
                }
                let concreteType = object.types?[columnName]
                if attribute is Array<AnyObject> {
                    createTableStatement.addColumn(with: columnName, type: .text(nil))
                } else {
                    switch concreteType {
                    case .blob:
                        createTableStatement.addColumn(with: columnName, type: .blob(nil))
                    case .double:
                        createTableStatement.addColumn(with: columnName, type: .double(nil))
                    case .integer:
                        createTableStatement.addColumn(with: columnName, type: .integer(nil))
                    default:
                        createTableStatement.addColumn(with: columnName, type: .text(nil))
                    }
                }
//                if case .blob = concreteType {
//                    createTableStatement.addColumn(with: columnName, type: .blob)
//                } else if let attribute = attribute as? NSNumber, !CFNumberIsFloatType(attribute as CFNumber) {
//                    createTableStatement.addColumn(with: columnName, type: .integer)
//                } else if attribute is Double || attribute is Float || attribute is Date {
//                    createTableStatement.addColumn(with: columnName, type: .double)
//                } else {
//                    createTableStatement.addColumn(with: columnName, type: .text)
//                }
                if columnName == "index" {
                    throw SundeedQLiteError.cantUseNameIndex(tableName: object.tableName)
                }
            }
            if objects[Sundeed.shared.primaryKey] != nil {
                createTableStatement.withPrimaryKey()
            }
            let statement: String? = createTableStatement.build()
            SundeedQLiteConnection.pool.execute(query: statement,
                                                parameters: nil)
            Sundeed.shared.tables.append(object.tableName)
        }
    }
    /** Try to create table for primitive data types if not already exists */
    func createTableForPrimitiveDataTypes(withTableName tableName: String,
                                          type: ParameterType = .text(nil)) {
        if  !Sundeed.shared.tables.contains(tableName) {
            let createTableStatement = StatementBuilder()
                .createTableStatement(tableName: tableName)
                .addColumn(with: Sundeed.shared.valueColumnName, type: type)
                .build()
            SundeedQLiteConnection.pool.execute(query: createTableStatement, parameters: nil)
            Sundeed.shared.tables.append(tableName)
        }
    }
}
