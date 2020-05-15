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
            let objects = object.objects,
            let mainTableName = object.tableName else { return }
        
        if !Sundeed.shared.tables.contains(mainTableName){
                let createTableStatement = StatementBuilder()
                    .createTableStatement(tableName: mainTableName)
                    
            for (columnName, attribute) in objects {
                    if let attribute = attribute as? SundeedObject {
                        try createTableIfNeeded(for: ObjectWrapper(tableName: columnName,
                                                                         className: "\(attribute)",
                                                                         objects: attribute))
                    } else if let attribute = attribute as? [SundeedObject] {
                        if let firstAttribute = attribute.first {
                            try createTableIfNeeded(for: ObjectWrapper(tableName: columnName,
                                                                             className: "\(firstAttribute)",
                                                                             objects: firstAttribute))
                        }
                    } else if attribute is Array<Any> {
                        createTableForPrimitiveDataTypes(withTableName: columnName)
                    }
                    createTableStatement.addColumn(with: columnName)
                    if columnName == "index" {
                        throw SundeedQLiteError.CantUseNameIndex(tableName: mainTableName)
                    }
                }
            if objects[Sundeed.shared.primaryKey] != nil {
                createTableStatement.withPrimaryKey()
            }
            let query = createTableStatement.build()
            SundeedQLiteConnection.pool.execute(query: query)
            Sundeed.shared.tables.append(mainTableName)
        }
    }
    
    /** Try to create table for primitive data types if not already exists */
    func createTableForPrimitiveDataTypes(withTableName tableName: String) {
        if  !Sundeed.shared.tables.contains(tableName){
            let createTableStatement = StatementBuilder()
                .createTableStatement(tableName: tableName)
                .addColumn(with: "VALUE")
                .build()
            SundeedQLiteConnection.pool.execute(query:createTableStatement)
            Sundeed.shared.tables.append(tableName)
        }
    }
}
