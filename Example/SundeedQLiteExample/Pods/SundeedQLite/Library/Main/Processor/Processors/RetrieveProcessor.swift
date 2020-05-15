//
//  SundeedRetrieveProcessor.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/11/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation
import SQLite3

class RetrieveProcessor {
    func retrieve(objectWrapper: ObjectWrapper,
                  withFilter filters:SundeedExpression<Bool>?...,
        subObjectHandler: (_ objectType: String)->ObjectWrapper?) -> [SundeedObject]{
        do {
            if let table = objectWrapper.tableName {
                var database = try SundeedQLiteConnection.pool.getConnection()
                if let columns = getDatabaseColumns(forTable: table),
                    !columns.isEmpty {
                    var array:[[String:Any]] = []
                    var statement: OpaquePointer?
                    
                    let selectStatement = StatementBuilder()
                        .selectStatement(tableName: table)
                        .isOrdered(objectWrapper.isOrdered)
                        .orderBy(columnName: objectWrapper.orderBy)
                        .isAscending(objectWrapper.asc)
                        .isCaseInsensitive(true)
                        .withFilters(filters)
                        .build()
                    
                    sqlite3_prepare_v2(database, selectStatement, -1, &statement, nil)
                    
                    while sqlite3_step(statement) == SQLITE_ROW {
                        var dictionary:[String:Any] = [:]
                        var primaryValue:String!
                        for column in columns{
                            if let columnValue = sqlite3_column_text(statement, Int32(column.key)) {
                                let value:String = String(cString: columnValue)
                                if value != "<null>" {
                                    dictionary[column.value] = value.replacingOccurrences(of: "\\\"", with: "\"")
                                }
                            }
                        }
                        if objectWrapper.hasPrimaryKey,
                            columns.contains(where: { $0.value == Sundeed.shared.primaryKey}) {
                            let column = columns.first { (column) -> Bool in
                                return column.value == Sundeed.shared.primaryKey
                                }!
                            if let columnValue = sqlite3_column_text(statement, Int32(column.key)) {
                                let value:String = String(cString: columnValue)
                                primaryValue = value.replacingOccurrences(of: "\\\"", with: "\"")
                            }
                        }
                        for row in dictionary {
                            if let value = row.value as? String {
                                if value.starts(with: Sundeed.shared.foreignPrefix){
                                    let configurations = value.split(separator: "|")
                                    let embededElementTable = String(describing: configurations[1])
                                    let embededElementPrimaryKey = String(configurations.last ?? "")
                                    
                                    if objectWrapper.hasPrimaryKey,
                                        let subObject = subObjectHandler(embededElementTable) {
                                        let filter1 = SundeedColumn(Sundeed.shared.foreignKey) == primaryValue
                                        let filter2 = SundeedColumn(Sundeed.shared.primaryKey) == String(embededElementPrimaryKey)
                                        dictionary[row.key] = self
                                            .retrieve(objectWrapper: subObject,
                                                                 withFilter: filter1, filter2,
                                                                 subObjectHandler: subObjectHandler)
                                    } else {
                                        throw SundeedQLiteError.PrimaryKeyError(tableName: objectWrapper.tableName ?? "")
                                    }
                                } else if value.starts(with: Sundeed.shared.foreignPrimitivePrefix) {
                                    let configurations = value.split(separator: "|")
                                    let embededElementTable = configurations[1]
                                    if objectWrapper.hasPrimaryKey {
                                        dictionary[row.key] = self.getDictionaryValuesForPrimitives(forTable: String(embededElementTable),
                                                                                                    withFilter: SundeedColumn(Sundeed.shared.foreignKey) == primaryValue)
                                        
                                    } else {
                                        throw SundeedQLiteError.PrimaryKeyError(tableName: objectWrapper.tableName ?? "")
                                    }
                                }
                            }
                        }
                        array.append(dictionary)
                    }
                    SundeedQLiteConnection.pool.closeConnection(database: database)
                    statement = nil
                    database = nil
                    return array
                } else {
                    database = nil
                    return []
                }
            } else {
                
                return []
            }
        } catch{
            return []
        }
    }
    
    private func getDictionaryValuesForPrimitives(forTable table: String, withFilter filter: SundeedExpression<Bool>?) -> [String]?{
        do {
            let database = try SundeedQLiteConnection.pool.getConnection()
            var statement: OpaquePointer?
            let selectStatement = StatementBuilder()
                .selectStatement(tableName: table)
                .withFilters(filter)
                .build()
            if sqlite3_prepare_v2(database, selectStatement, -1, &statement, nil) == SQLITE_OK,
                let columns = getDatabaseColumns(forTable: table) {
                var array: [String] = []
                for column in columns where column.value == "VALUE" {
                    while sqlite3_step(statement) == SQLITE_ROW {
                        if let columnValue = sqlite3_column_text(statement, Int32(column.key)) {
                            let value:String = String(cString: columnValue)
                            if value != "<null>" {
                                array.append(value.replacingOccurrences(of: "\\\"", with: "\""))
                            }
                        }
                    }
                }
                return array
            }
        } catch {}
        return nil
    }
    
    private func getDatabaseColumns(forTable table:String)->[Int:String]?{
        do {
            if let database = try SundeedQLiteConnection.pool.getConnection(toWrite: true) {
                var columnsStatement: OpaquePointer?
                var dictionary:[Int:String] = [:]
                sqlite3_prepare_v2(database,
                                   "PRAGMA table_info(\(table));",
                    -1,
                    &columnsStatement, nil)
                var index = 0
                while sqlite3_step(columnsStatement) == SQLITE_ROW {
                    if let columnName = sqlite3_column_text(columnsStatement, 1) {
                        dictionary[index] = String(cString: columnName)
                        index += 1
                    }
                }
                columnsStatement = nil
                SundeedQLiteConnection.pool.closeConnection(database: database)
                return dictionary
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
