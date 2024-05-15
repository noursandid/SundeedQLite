//
//  SundeedUpdateStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/10/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class UpdateStatement: Statement {
    private var tableName: String
    private var keyValues: [(String, Any?)] = []
    private var values: [ParameterType] = []
    private var filters: [SundeedExpression<Bool>] = []
    init(with tableName: String) {
        self.tableName = tableName
    }
    @discardableResult
    func add(key: String, value: Any?) -> Self {
        keyValues.append((key, value))
        return self
    }
    @discardableResult
    func withFilters(_ filters: [SundeedExpression<Bool>?]) -> Self {
        self.filters = filters.compactMap({$0})
        return self
    }
    func build() -> (query: String, parameters: [ParameterType])? {
        guard !keyValues.isEmpty else { return nil }
        var statement = "UPDATE \(tableName) SET "
        addKeyValues(toStatement: &statement)
        addFilters(toStatement: &statement)
        return (query: statement, parameters: values)
    }
    private func addKeyValues(toStatement statement: inout String) {
        for (index, (key, value)) in keyValues.enumerated() {
            let value = value ?? ""
            statement.append("\(key) = ?")
            values.append(getParameter(value))
            addSeparatorIfNeeded(separator: ", ",
                                 forStatement: &statement,
                                 needed: isLastIndex(index: index, in: keyValues))
        }
    }
    private func addFilters(toStatement statement: inout String) {
        statement.append(" WHERE ")
        if !filters.isEmpty {
            for (index, filter) in filters.enumerated() {
                statement.append(filter.toQuery())
                addSeparatorIfNeeded(separator: " AND ",
                                     forStatement: &statement,
                                     needed: isLastIndex(index: index, in: filters))
            }
        } else {
            statement.append("1")
        }
    }
}
