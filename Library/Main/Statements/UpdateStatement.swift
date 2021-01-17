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
    private var keyValues: [(String, String)] = []
    private var filters: [SundeedExpression<Bool>] = []
    init(with tableName: String) {
        self.tableName = tableName
    }
    @discardableResult
    func add(key: String, value: String) -> Self {
        keyValues.append((key, value))
        return self
    }
    @discardableResult
    func withFilters(_ filters: [SundeedExpression<Bool>?]) -> Self {
        self.filters = filters.compactMap({$0})
        return self
    }
    func build() -> String? {
        guard !keyValues.isEmpty else { return nil }
        var statement = "UPDATE \(tableName) SET "
        addKeyValues(toStatement: &statement)
        addFilters(toStatement: &statement)
        return statement
    }
    private func addKeyValues(toStatement statement: inout String) {
        for (index, (key, value)) in keyValues.enumerated() {
            let value = value
            let quotation = getQuotation(forValue: value)
            statement.append("\(key) = \(quotation)\(value)\(quotation)")
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
