//
//  SundeedCreateTableStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/9/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class CreateTableStatement {
    private var tableName: String
    private var hasPrimaryKey: Bool = false
    private var columnNames: [String] = []
    init(with tableName: String) {
        self.tableName = tableName
    }
    @discardableResult
    func addColumn(with columnName: String) -> Self {
        columnNames.append(columnName)
        return self
    }
    @discardableResult
    func withPrimaryKey() -> Self {
        self.hasPrimaryKey = true
        return self
    }
    func build() -> String? {
        var statement = "CREATE TABLE IF NOT EXISTS \(tableName) (\(Sundeed.shared.offlineID) INTEGER PRIMARY KEY, \(Sundeed.shared.foreignKey) TEXT, \(Sundeed.shared.fieldNameLink) TEXT" 
        for columnName in columnNames {
            statement.append(",\(columnName) TEXT")
        }
        if hasPrimaryKey {
            statement.append(",CONSTRAINT unq\(tableName) UNIQUE (\(Sundeed.shared.foreignKey),\(Sundeed.shared.primaryKey),\(Sundeed.shared.fieldNameLink))")
        }
        statement.append(");")
        return statement
    }
}
