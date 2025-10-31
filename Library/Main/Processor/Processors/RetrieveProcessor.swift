//
//  SundeedRetrieveProcessor.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/11/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation
import SQLite3

class RetrieveProcessor: Processor {
    func retrieve(objectWrapper: ObjectWrapper,
                  orderBy order: SundeedColumn? = nil,
                  ascending: Bool? = nil,
                  withFilter filters: [SundeedExpression?] = [],
                  limit: Int? = nil,
                  skip: Int? = nil,
                  excludeIfIsForeign: Bool = false,
                  subObjectHandler: (_ objectType: String) -> ObjectWrapper?) -> [SundeedObject] {
        let database: OpaquePointer? = SundeedQLiteConnection.pool.connection()
        let columns = getDatabaseColumns(forTable: objectWrapper.tableName)
        SundeedLogger.info("Retrieving \(objectWrapper.tableName)")
        if !columns.isEmpty {
            var statement: OpaquePointer?
            let query: String? = StatementBuilder()
                .selectStatement(tableName: objectWrapper.tableName)
                .isOrdered(order != nil || objectWrapper.isOrdered)
                .orderBy(columnName: order?.value ?? objectWrapper.orderBy)
                .isAscending(ascending ?? objectWrapper.asc)
                .isCaseInsensitive(true)
                .withFilters(filters)
                .limit(limit)
                .skip(skip)
                .excludeIfIsForeign(excludeIfIsForeign)
                .build()
            
            sqlite3_prepare_v2(database, query, -1, &statement, nil)
            let array: [[String: Any]] = fetchStatementResult(statement: statement,
                                                              columns: columns,
                                                              objectWrapper: objectWrapper,
                                                              subObjectHandler: subObjectHandler)
            SundeedLogger.debug("Found for \(objectWrapper.tableName): \(array)")
            SundeedQLiteConnection.pool.closeConnection(database)
            return array
        } else {
            SundeedQLiteConnection.pool.closeConnection(database)
        }
        return []
    }
    
    func fetchStatementResult(statement: OpaquePointer?,
                              columns: [(columnName: String, columnType: ParameterType)],
                              objectWrapper: ObjectWrapper,
                              subObjectHandler: (_ objectType: String) -> ObjectWrapper?) -> [[String: Any]] {
        var array: [[String: Any]] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            var dictionary: [String: Any] = [:]
            var primaryValue: String?
            for (index, column) in columns.enumerated() {
                if sqlite3_column_type(statement, Int32(index)) == SQLITE_NULL {
                    let columnName = column.columnName
                    dictionary[columnName] = nil
                } else if SQLITE_BLOB == sqlite3_column_type(statement, Int32(index)),
                   let databaseValue = sqlite3_column_blob(statement, Int32(index)) {
                    let size = Int(sqlite3_column_bytes(statement, Int32(index)))
                    let value: Data = Data(bytes: databaseValue, count: size)
                    dictionary[column.columnName] = value
                } else if case .integer = column.columnType {
                    let databaseValue = sqlite3_column_int(statement, Int32(index))
                    let value: Int = Int(databaseValue)
                    let columnName = column.columnName
                    dictionary[columnName] = value
                } else if case .double = column.columnType {
                    let databaseValue = sqlite3_column_double(statement, Int32(index))
                    let value: Double = Double(databaseValue)
                    let columnName = column.columnName
                    dictionary[columnName] = value
                } else if let databaseValue = sqlite3_column_text(statement, Int32(index)) {
                    let value: String = normalizeColumnValue(databaseValue)
                    let columnName = column.columnName
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
                        let filter1 = SundeedColumn(Sundeed.shared.foreignKey) == primaryValue
                        let filter2 = SundeedColumn(Sundeed.shared.fieldNameLink) == embededElementFieldNameLink
                        var filter3: SundeedExpression?
                        if let embededElementPrimaryKey = embededElementPrimaryKey {
                            filter3 = SundeedColumn(Sundeed.shared.primaryKey) == embededElementPrimaryKey
                        }
                        dictionary[row.key] = self
                            .retrieve(objectWrapper: subObject,
                                      withFilter: [filter1, filter2, filter3],
                                      excludeIfIsForeign: false,
                                      subObjectHandler: subObjectHandler)
                    }
                } else if value.starts(with: Sundeed.shared.foreignPrimitivePrefix) {
                    let configurations = value.split(separator: "|")
                    let embededElementTable = String(configurations[1])
                    let filter = SundeedColumn(Sundeed.shared.foreignKey) == primaryValue
                    dictionary[row.key] = self.getPrimitiveValues(forTable: embededElementTable,
                                                                  withFilter: filter)
                }
            }
        }
    }
    func getPrimitiveValues(forTable table: String,
                            withFilter filter: SundeedExpression?) -> [Any]? {
        let database = SundeedQLiteConnection.pool.connection()
        var statement: OpaquePointer?
        let selectStatement = StatementBuilder()
            .selectStatement(tableName: table)
            .withFilters(filter)
            .build()
        if sqlite3_prepare_v2(database, selectStatement, -1, &statement, nil) == SQLITE_OK {
            let columns = getDatabaseColumns(forTable: table)
            var array: [Any] = []
            while sqlite3_step(statement) == SQLITE_ROW {
                for (index, column) in columns.enumerated() where column.columnName == Sundeed.shared.valueColumnName {
                    if SQLITE_BLOB == sqlite3_column_type(statement, Int32(index)),
                       let databaseValue = sqlite3_column_blob(statement, Int32(index)) {
                        let size = Int(sqlite3_column_bytes(statement, Int32(index)))
                        let value: Data = Data(bytes: databaseValue, count: size)
                        array.append(value)
                    } else if case .double = column.columnType {
                        let databaseValue = sqlite3_column_double(statement, Int32(index))
                        let value: Double = Double(databaseValue)
                        array.append(value)
                    } else if case .integer = column.columnType {
                        let databaseValue = sqlite3_column_int(statement, Int32(index))
                        let value: Int = Int(databaseValue)
                        array.append(value)
                    } else if let columnValue = sqlite3_column_text(statement, Int32(index)) {
                        let value: String = String(cString: columnValue)
                        if value != Sundeed.shared.databaseNull {
                            array.append(value.replacingOccurrences(of: "\\\"", with: "\""))
                        }
                    }
                }
            }
            SundeedQLiteConnection.pool.closeConnection(database)
            return array
        } else {
            SundeedQLiteConnection.pool.closeConnection(database)
        }
        return nil
    }
    func normalizeColumnValue(_ columnValue: UnsafePointer<UInt8>) -> String {
        String(cString: columnValue).replacingOccurrences(of: "\\\"", with: "\"")
    }
}
