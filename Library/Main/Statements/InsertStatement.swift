//
//  SundeedInsertStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/10/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class InsertStatement: Statement {
    let queue = DispatchQueue(label: "thread-safe-insert-statement", attributes: .concurrent)
    private var tableName: String
    private var columns: [String: ParameterType]
    private var keyValues: [(String, Any?)] = []
    private var values: [ParameterType] = []
    init(with tableName: String) {
        self.tableName = tableName
        self.columns = Processor().getDatabaseColumns(forTable: tableName).reduce(into: [String: ParameterType]()) { result, element in
            result[element.columnName] = element.columnType
        }
    }
    @discardableResult
    func add(key: String, value: Any?) -> Self {
        queue.sync {
            keyValues.append((key, value))
            return self
        }
    }
    func build() -> (query: String, parameters: [ParameterType])? {
        queue.sync {
            guard !keyValues.isEmpty else { return nil }
            var statement: String = "REPLACE INTO \(tableName) ("
            addKeysAndValues(toStatement: &statement)
            SundeedLogger.debug("Insert Statement: \(statement), with parameters: \(values)")
            return (query: statement, parameters: values)
        }
    }
    private func addKeysAndValues(toStatement statement: inout String) {
        queue.sync {
            var valuesStatement: String = ") VALUES ("
            for (index, (key, value)) in keyValues.enumerated() {
                statement.append(key)
                valuesStatement.append("?")
                let columnType = self.columns[key] ?? .text("")
                values.append(columnType.withValue(value))
                let needed = isLastIndex(index: index, in: keyValues)
                addSeparatorIfNeeded(separator: ", ",
                                     forStatement: &statement,
                                     needed: needed)
                addSeparatorIfNeeded(separator: ", ",
                                     forStatement: &valuesStatement,
                                     needed: needed)
            }
            valuesStatement.append(");")
            statement = "\(statement)\(valuesStatement)"
        }
    }
}
