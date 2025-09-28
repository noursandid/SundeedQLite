//
//  SundeedDeleteStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/10/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class DeleteStatement: Statement {
    let queue = DispatchQueue(label: "thread-safe-delete-statement", attributes: .concurrent)
    private var tableName: String
    private var filters: [SundeedExpression<Bool>] = []
    init(with tableName: String) {
        self.tableName = tableName
    }
    @discardableResult
    func withFilters(_ filters: [SundeedExpression<Bool>?]) -> Self {
        queue.sync {
            self.filters = filters.compactMap({$0})
            return self
        }
    }
    func build() -> String? {
        queue.sync {
            var statement: String = "DELETE FROM \(tableName) WHERE "
            addFilters(forStatement: &statement)
            SundeedLogger.debug("Delete Statement: \(statement)")
            return statement
        }
    }
    private func addFilters(forStatement statement: inout String) {
        queue.sync {
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
