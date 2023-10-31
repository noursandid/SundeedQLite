//
//  SundeedDeleteStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/10/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class DeleteStatement: Statement {
    private var tableName: String
    private var filters: [SundeedExpression<Bool>] = []
    init(with tableName: String) {
        self.tableName = tableName
    }
    @discardableResult
    func withFilters(_ filters: [SundeedExpression<Bool>?]) -> Self {
        self.filters = filters.compactMap({$0})
        return self
    }
    func build() -> String? {
        var statement: String = "DELETE FROM \(tableName) WHERE "
        addFilters(forStatement: &statement)
        return statement
    }
    private func addFilters(forStatement statement: inout String) {
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
