//
//  SundeedCreateTableProcessor.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/11/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class CreateTableProcessor {
    func createTableIfNeeded(for object: ObjectWrapper?) throws {
        guard let object = object,
            let objects = object.objects else {
                throw SundeedQLiteError.noObjectPassed
        }
        if !Sundeed.shared.tables.contains(object.tableName) {
            let createTableStatement = StatementBuilder()
                .createTableStatement(tableName: object.tableName)
            for (columnName, attribute) in objects {
                if let attribute = attribute as? ObjectWrapper {
                    try createTableIfNeeded(for: attribute)
                } else if let attribute = attribute as? [ObjectWrapper] {
                    if let firstAttribute = attribute.first {
                        try createTableIfNeeded(for: firstAttribute)
                    }
                } else
                    if attribute is [Any] {
                    createTableForPrimitiveDataTypes(withTableName: columnName)
                }
                createTableStatement.addColumn(with: columnName)
                if columnName == "index" {
                    throw SundeedQLiteError.cantUseNameIndex(tableName: object.tableName)
                }
            }
            if objects[Sundeed.shared.primaryKey] != nil {
                createTableStatement.withPrimaryKey()
            }
            let query: String? = createTableStatement.build()
            SundeedQLiteConnection.pool.execute(query: query)
            Sundeed.shared.tables.append(object.tableName)
        }
    }
    /** Try to create table for primitive data types if not already exists */
    func createTableForPrimitiveDataTypes(withTableName tableName: String) {
        if  !Sundeed.shared.tables.contains(tableName) {
            let createTableStatement = StatementBuilder()
                .createTableStatement(tableName: tableName)
                .addColumn(with: Sundeed.shared.valueColumnName)
                .build()
            SundeedQLiteConnection.pool.execute(query: createTableStatement)
            Sundeed.shared.tables.append(tableName)
        }
    }
}
