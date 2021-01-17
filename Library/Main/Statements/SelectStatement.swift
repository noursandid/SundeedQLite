//
//  SundeedSelectStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/10/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class SelectStatement: Statement {
    private var tableName: String
    private var filters: [SundeedExpression<Bool>] = []
    private var caseInSensitive: Bool = false
    private var orderByColumnName: String?
    private var isOrdered: Bool = false
    private var ascending: Bool = true
    init(with tableName: String) {
        self.tableName = tableName
    }
    @discardableResult
    func isCaseInsensitive(_ isCaseInsensitive: Bool) -> Self {
        self.caseInSensitive = isCaseInsensitive
        return self
    }
    @discardableResult
    func isAscending(_ isAscending: Bool) -> Self {
        self.ascending = isAscending
        return self
    }
    @discardableResult
    func isOrdered(_ isOrdered: Bool) -> Self {
        self.isOrdered = isOrdered
        return self
    }
    @discardableResult
    func orderBy(columnName: String?) -> Self {
        orderByColumnName = columnName
        return self
    }
    @discardableResult
    func withFilters(_ filters: SundeedExpression<Bool>?...) -> Self {
        self.filters = filters.compactMap({$0})
        return self
    }
    @discardableResult
    func withFilters(_ filters: [SundeedExpression<Bool>?]) -> Self {
        self.filters = filters.compactMap({$0})
        return self
    }
    func build() -> String? {
        var statement = "SELECT * FROM \(tableName)"
        addFilters(toStatement: &statement)
        addOrderBy(toStatement: &statement)
        statement.append(";")
        return statement
    }
    private func addFilters(toStatement statement: inout String) {
        if !filters.isEmpty {
            statement += " WHERE "
            for (index, filter) in filters.enumerated() {
                let whereStatement = filterToQuery(filter: filter)
                statement.append(whereStatement)
                addSeparatorIfNeeded(separator: " AND ",
                                     forStatement: &statement,
                                     needed: isLastIndex(index: index, in: filters))
            }
        }
    }
    private func addOrderBy(toStatement statement: inout String) {
        statement.append(" ORDER BY ")
        if isOrdered,
            let orderByColumnName = orderByColumnName {
            let quoations = getQuotation(forValue: orderByColumnName)
            let condition = "\(quoations)\(orderByColumnName)\(quoations)"
            statement.append(condition)
        } else {
            statement.append("\'SUNDEED_OFFLINE_ID\'")
        }
        addCaseInsensitive(toStatement: &statement)
        let sorting = ascending ? " ASC" : " DESC"
        statement.append(sorting)
    }
    private func addCaseInsensitive(toStatement statement: inout String) {
        if caseInSensitive {
            statement.append(" COLLATE NOCASE")
        }
    }
    private func filterToQuery(filter: SundeedExpression<Bool>) -> String {
        let template = filter.template
        let binding = filter.bindings
        let quotation = getQuotation(forValue: binding)
        return "\(template) = \(quotation)\(binding)\(quotation)"
    }
}
