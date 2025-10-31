//
//  SundeedSelectStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/10/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class SelectStatement: Statement {
    let queue = DispatchQueue(label: "thread-safe-select-statement", attributes: .concurrent)
    private var tableName: String
    private var filters: [SundeedExpression] = []
    private var caseInSensitive: Bool = false
    private var orderByColumnName: String?
    private var isOrdered: Bool = false
    private var ascending: Bool = true
    private var limit: Int?
    private var skip: Int?
    
    init(with tableName: String) {
        self.tableName = tableName
    }
    @discardableResult
    func isCaseInsensitive(_ isCaseInsensitive: Bool) -> Self {
        queue.sync {
            self.caseInSensitive = isCaseInsensitive
            return self
        }
    }
    @discardableResult
    func isAscending(_ isAscending: Bool) -> Self {
        queue.sync {
            self.ascending = isAscending
            return self
        }
    }
    @discardableResult
    func isOrdered(_ isOrdered: Bool) -> Self {
        queue.sync {
            self.isOrdered = isOrdered
            return self
        }
    }
    @discardableResult
    func orderBy(columnName: String?) -> Self {
        queue.sync {
            orderByColumnName = columnName
            return self
        }
    }
    @discardableResult
    func limit(_ limit: Int?) -> Self {
        queue.sync {
            self.limit = limit
            return self
        }
    }
    @discardableResult
    func skip(_ skip: Int?) -> Self {
        queue.sync {
            self.skip = skip
            return self
        }
    }
    @discardableResult
    func withFilters(_ filters: SundeedExpression?...) -> Self {
        queue.sync {
            self.filters = filters.compactMap({$0})
            return self
        }
    }
    @discardableResult
    func withFilters(_ filters: [SundeedExpression?]) -> Self {
        queue.sync {
            self.filters = filters.compactMap({$0})
            return self
        }
    }
    @discardableResult
    func excludeIfIsForeign(_ exclude: Bool) -> Self {
        queue.sync {
            if exclude {
                self.filters = self.filters + [SundeedColumn(Sundeed.shared.foreignKey) == nil]
            }
            return self
        }
    }
    func build() -> String? {
        queue.sync {
            var statement = "SELECT * FROM \(tableName)"
            addFilters(toStatement: &statement)
            addOrderBy(toStatement: &statement)
            addLimit(toStatement: &statement)
            addSkip(toStatement: &statement)
            statement.append(";")
            SundeedLogger.debug("Select Statement: \(statement)")
            return statement
        }
    }
    private func addFilters(toStatement statement: inout String) {
        queue.sync {
            if !filters.isEmpty {
                statement += " WHERE "
                for (index, filter) in filters.enumerated() {
                    let whereStatement = filter.toQuery()
                    statement.append(whereStatement)
                    addSeparatorIfNeeded(separator: " AND ",
                                         forStatement: &statement,
                                         needed: isLastIndex(index: index, in: filters))
                }
            }
        }
    }
    private func addOrderBy(toStatement statement: inout String) {
        queue.sync {
            statement.append(" ORDER BY")
            if isOrdered,
               let orderByColumnName = orderByColumnName {
                let condition = " \(orderByColumnName)"
                statement.append(condition)
            } else {
                statement.append(" SUNDEED_OFFLINE_ID")
            }
            addCaseInsensitive(toStatement: &statement)
            let sorting = ascending ? " ASC" : " DESC"
            statement.append(sorting)
        }
    }
    private func addLimit(toStatement statement: inout String) {
        queue.sync {
            if let limit {
                statement.append(" LIMIT \(limit)")
            }
        }
    }
    private func addSkip(toStatement statement: inout String) {
        queue.sync {
            if let skip {
                if limit == nil {
                    statement.append(" LIMIT -1")
                }
                statement.append(" OFFSET \(skip)")
            }
        }
    }
    private func addCaseInsensitive(toStatement statement: inout String) {
        queue.sync {
            if caseInSensitive {
                statement.append(" COLLATE NOCASE")
            }
        }
    }
}
