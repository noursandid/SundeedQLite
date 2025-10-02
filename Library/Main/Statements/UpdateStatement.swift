//
//  SundeedUpdateStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/10/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class UpdateStatement: Statement {
    let queue = DispatchQueue(label: "thread-safe-update-statement", attributes: .concurrent)
    private var tableName: String
    private var columns: [String: ParameterType]
    private var keyValues: [(String, Any?)] = []
    private var values: [ParameterType] = []
    private var filters: [SundeedExpression<Bool>] = []
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
    @discardableResult
    func withFilters(_ filters: [SundeedExpression<Bool>?]) -> Self {
        queue.sync {
            self.filters = filters.compactMap({$0})
            return self
        }
    }
    func build() -> (query: String, parameters: [ParameterType])? {
        queue.sync {
            guard !keyValues.isEmpty else { return nil }
            var statement = "UPDATE \(tableName) SET "
            addKeyValues(toStatement: &statement)
            addFilters(toStatement: &statement)
            SundeedLogger.debug("Update Statement: \(statement), with parameters \(values)")
            return (query: statement, parameters: values)
        }
    }
    private func addKeyValues(toStatement statement: inout String) {
        queue.sync {
            for (index, (key, value)) in keyValues.enumerated() where self.columns[key] != nil {
                statement.append("\(key) = ?")
                let columnType = self.columns[key] ?? .text("")
                values.append(columnType.withValue(value))
                addSeparatorIfNeeded(separator: ", ",
                                     forStatement: &statement,
                                     needed: isLastIndex(index: index, in: keyValues))
            }
        }
    }
    private func addFilters(toStatement statement: inout String) {
        queue.sync {
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
}
