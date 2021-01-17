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
                  withFilter filters: SundeedExpression<Bool>?...,
                  subObjectHandler: (_ objectType: String) -> ObjectWrapper?) -> [SundeedObject] {
        var database: OpaquePointer? = try? SundeedQLiteConnection.pool.getConnection()
        let columns = getDatabaseColumns(forTable: objectWrapper.tableName)
        if !columns.isEmpty {
            var statement: OpaquePointer?
            let query: String? = StatementBuilder()
                .selectStatement(tableName: objectWrapper.tableName)
                .isOrdered(objectWrapper.isOrdered)
                .orderBy(columnName: objectWrapper.orderBy)
                .isAscending(objectWrapper.asc)
                .isCaseInsensitive(true)
                .withFilters(filters)
                .build()
            
            sqlite3_prepare_v2(database, query, -1, &statement, nil)
            let array: [[String: Any]] = fetchStatementResult(statement: statement,
                                                              columns: columns,
                                                              objectWrapper: objectWrapper,
                                                              subObjectHandler: subObjectHandler)
            SundeedQLiteConnection.pool.closeConnection(database: database)
            statement = nil
            database = nil
            return array
        }
        return []
    }
    
    func fetchStatementResult(statement: OpaquePointer?,
                              columns: [Int : String],
                              objectWrapper: ObjectWrapper,
                              subObjectHandler: (_ objectType: String) -> ObjectWrapper?) -> [[String: Any]] {
        var array: [[String: Any]] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            var dictionary: [String: Any] = [:]
            var primaryValue: String?
            for column in columns {
                if let databaseValue = sqlite3_column_text(statement, Int32(column.key)) {
                    let value: String = normalizeColumnValue(databaseValue)
                    let columnName = column.value
                    if value != Sundeed.shared.databaseNull {
                        dictionary[columnName] = value
                    }
                    if columnName == Sundeed.shared.primaryKey {
                        primaryValue = value
                    }
                }
            }
            fetchForeignObjects(withObject: objectWrapper,
                                primaryValue: primaryValue,
                                inDictionary: &dictionary,
                                subObjectHandler: subObjectHandler)
            array.append(dictionary)
        }
        return array
    }
    
    func fetchForeignObjects(withObject objectWrapper: ObjectWrapper,
                             primaryValue: String?,
                             inDictionary dictionary: inout [String: Any],
                             subObjectHandler: (_ objectType: String) -> ObjectWrapper?) {
        guard let primaryValue = primaryValue else { return }
        for row in dictionary {
            if let value = row.value as? String {
                if value.starts(with: Sundeed.shared.foreignPrefix) {
                    let configurations = value.split(separator: "|")
                    let embededElementTable = String(describing: configurations[1])
                    let embededElementFieldNameLink = String(configurations[2])
                    var embededElementPrimaryKey: String?
                    if configurations.count == 4 {
                        embededElementPrimaryKey = String(configurations[3])
                    }
                    if let subObject = subObjectHandler(embededElementTable) {
                        let filter1 = SundeedColumn(Sundeed
                                                        .shared.foreignKey) == primaryValue
                        let filter2 = SundeedColumn(Sundeed.shared
                                                        .fieldNameLink) == embededElementFieldNameLink
                        var filter3: SundeedExpression<Bool>?
                        if let embededElementPrimaryKey = embededElementPrimaryKey {
                            filter3 = SundeedColumn(Sundeed.shared
                                                        .primaryKey) == embededElementPrimaryKey
                        }
                        dictionary[row.key] = self
                            .retrieve(objectWrapper: subObject,
                                      withFilter: filter1, filter2, filter3,
                                      subObjectHandler: subObjectHandler)
                    }
                } else if value.starts(with: Sundeed.shared.foreignPrimitivePrefix) {
                    let configurations = value.split(separator: "|")
                    let embededElementTable = String(configurations[1])
                    let filter = SundeedColumn(Sundeed.shared.foreignKey) == primaryValue
                    dictionary[row.key] = self
                        .getPrimitiveValues(forTable: embededElementTable,
                                            withFilter: filter)
                }
            }
        }
    }
    func getPrimitiveValues(forTable table: String,
                            withFilter filter: SundeedExpression<Bool>?) -> [String]? {
        let database = try? SundeedQLiteConnection.pool.getConnection()
        var statement: OpaquePointer?
        let selectStatement = StatementBuilder()
            .selectStatement(tableName: table)
            .withFilters(filter)
            .build()
        if sqlite3_prepare_v2(database, selectStatement, -1, &statement, nil) == SQLITE_OK {
            let columns = getDatabaseColumns(forTable: table)
            var array: [String] = []
            for column in columns where column.value == Sundeed.shared.valueColumnName {
                while sqlite3_step(statement) == SQLITE_ROW {
                    if let columnValue = sqlite3_column_text(statement, Int32(column.key)) {
                        let value: String = String(cString: columnValue)
                        if value != Sundeed.shared.databaseNull {
                            array.append(value.replacingOccurrences(of: "\\\"", with: "\""))
                        }
                    }
                }
            }
            SundeedQLiteConnection.pool.closeConnection(database: database)
            return array
        }
        SundeedQLiteConnection.pool.closeConnection(database: database)
        return nil
    }
    func getDatabaseColumns(forTable table: String) -> [Int: String] {
        let database = try? SundeedQLiteConnection.pool.getConnection(toWrite: false)
        var columnsStatement: OpaquePointer?
        var array: [String] = []
        var dictionary: [Int: String] = [:]
        sqlite3_prepare_v2(database,
                           "PRAGMA table_info(\(table));",-1,
                           &columnsStatement, nil)
        while sqlite3_step(columnsStatement) == SQLITE_ROW {
            if let columnName = sqlite3_column_text(columnsStatement, 1) {
                array.append(String(cString: columnName))
            }
        }
        array.enumerated().forEach({dictionary[$0] = $1})
        columnsStatement = nil
        SundeedQLiteConnection.pool.closeConnection(database: database)
        return dictionary
    }
    func normalizeColumnValue(_ columnValue: UnsafePointer<UInt8>) -> String {
        String(cString: columnValue).replacingOccurrences(of: "\\\"", with: "\"")
    }
}
