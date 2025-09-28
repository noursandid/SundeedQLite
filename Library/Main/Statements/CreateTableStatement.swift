//
//  SundeedCreateTableStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/9/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class CreateTableStatement {
    let queue = DispatchQueue(label: "thread-safe-create-table-statement", attributes: .concurrent)
    enum ColumnType: String {
        case text = "TEXT"
        case blob = "BLOB"
    }
    private var tableName: String
    private var hasPrimaryKey: Bool = false
    private var columns: [(name: String, type: String)] = []
    init(with tableName: String) {
        self.tableName = tableName
    }
    @discardableResult
    func addColumn(with columnName: String, type: ColumnType) -> Self {
        queue.sync {
            columns.append((name: columnName, type: type.rawValue))
            return self
        }
    }
    @discardableResult
    func withPrimaryKey() -> Self {
        self.hasPrimaryKey = true
        return self
    }
    func build() -> String? {
        queue.sync {
            var statement = "CREATE TABLE IF NOT EXISTS \(tableName) (\(Sundeed.shared.offlineID) INTEGER PRIMARY KEY, \(Sundeed.shared.foreignKey) TEXT, \(Sundeed.shared.fieldNameLink) TEXT"
            for column in columns {
                statement.append(", \(column.name) \(column.type)")
            }
            if hasPrimaryKey {
                statement.append(",CONSTRAINT unq\(tableName) UNIQUE (\(Sundeed.shared.foreignKey),\(Sundeed.shared.primaryKey),\(Sundeed.shared.fieldNameLink))")
            }
            statement.append(");")
            SundeedLogger.debug("Create Table Statement: \(statement)")
            return statement
        }
    }
}
