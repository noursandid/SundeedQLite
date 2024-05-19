//
//  SundeedInsertStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/10/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class InsertStatement: Statement {
    private var tableName: String
    private var keyValues: [(String, Any?)] = []
    private var values: [ParameterType] = []
    init(with tableName: String) {
        self.tableName = tableName
    }
    @discardableResult
    func add(key: String, value: Any?) -> Self {
        keyValues.append((key, value))
        return self
    }
    func build() -> (query: String, parameters: [ParameterType])? {
        guard !keyValues.isEmpty else { return nil }
        var statement: String = "REPLACE INTO \(tableName) ("
        addKeysAndValues(toStatement: &statement)
        return (query: statement, parameters: values)
    }
    private func addKeysAndValues(toStatement statement: inout String) {
        var valuesStatement: String = ") VALUES ("
        for (index, (key, value)) in keyValues.enumerated() {
            let value = value ?? ""
            statement.append(key)
            valuesStatement.append("?")
            values.append(getParameter(value))
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
