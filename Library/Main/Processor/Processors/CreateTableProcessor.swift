//
//  SundeedCreateTableProcessor.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/11/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class CreateTableProcessor {
    func createTableIfNeeded(for object: ObjectWrapper?) async throws {
        guard let object = object,
            let objects = object.objects else {
                throw SundeedQLiteError.noObjectPassed
        }
        if !Sundeed.shared.tables.contains(object.tableName) {
            let createTableStatement = StatementBuilder()
                .createTableStatement(tableName: object.tableName)
            for (columnName, attribute) in objects {
                if let attribute = attribute as? ObjectWrapper {
                    try await createTableIfNeeded(for: attribute)
                } else if let attribute = attribute as? [ObjectWrapper] {
                    if let firstAttribute = attribute.first {
                        try await createTableIfNeeded(for: firstAttribute)
                    }
                } else if attribute is [Any] {
                    if let array = attribute as? [Any], let _ = array.first as? Data {
                        await createTableForPrimitiveDataTypes(withTableName: columnName, type: .blob)
                    } else {
                        await createTableForPrimitiveDataTypes(withTableName: columnName)
                    }
                }
                
                if attribute is Data {
                    createTableStatement.addColumn(with: columnName, type: .blob)
                } else {
                    createTableStatement.addColumn(with: columnName, type: .text)
                }
                if columnName == "index" {
                    throw SundeedQLiteError.cantUseNameIndex(tableName: object.tableName)
                }
            }
            if objects[Sundeed.shared.primaryKey] != nil {
                createTableStatement.withPrimaryKey()
            }
            let statement: String? = createTableStatement.build()
            await SundeedQLiteConnection.pool.execute(query: statement,
                                                parameters: nil)
            Sundeed.shared.tables.append(object.tableName)
        }
    }
    /** Try to create table for primitive data types if not already exists */
    func createTableForPrimitiveDataTypes(withTableName tableName: String,
                                          type: CreateTableStatement.ColumnType = .text) async {
        if  !Sundeed.shared.tables.contains(tableName) {
            let createTableStatement = StatementBuilder()
                .createTableStatement(tableName: tableName)
                .addColumn(with: Sundeed.shared.valueColumnName, type: type)
                .build()
            await SundeedQLiteConnection.pool.execute(query: createTableStatement, parameters: nil)
            Sundeed.shared.tables.append(tableName)
        }
    }
}
