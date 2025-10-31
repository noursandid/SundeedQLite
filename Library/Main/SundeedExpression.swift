//
//  SundeedExpression.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 30/09/2025.
//  Copyright © 2025 LUMBERCODE. All rights reserved.
//

import Foundation

/** SundeedColumn("columnName") == "value" */
public struct SundeedExpression: @unchecked Sendable {
    enum LogicalOperator: String {
        case and = "AND"
        case or  = "OR"
    }
    
    enum ComparisonOperator: String {
        case equal = "="
        case notEqual = "<>"
        case greaterThan = ">"
        case greaterThanOrEqual = ">="
        case lessThan = "<"
        case lessThanOrEqual = "<="
    }

    private enum Node {
        case comparison(key: String, value: Any?, comparison: ComparisonOperator, positive: Bool)
        case group(children: [SundeedExpression], op: LogicalOperator)
    }

    private let node: Node

    init(_ key: String, _ value: Any?, comparison: ComparisonOperator = .equal, positive: Bool = true) {
        self.node = .comparison(key: key, value: value, comparison: comparison, positive: positive)
    }

    // MARK: - Group initializer (combine other expressions with a logical operator)
    init(_ expressions: [SundeedExpression], logicalOperator: LogicalOperator = .and) {
        var flattened: [SundeedExpression] = []
        for expr in expressions {
            if case .group(let children, let op) = expr.node, op == logicalOperator {
                // append children's elements (flatten)
                flattened.append(contentsOf: children)
            } else {
                flattened.append(expr)
            }
        }
        if flattened.count == 1 {
            self.node = flattened[0].node
        } else {
            self.node = .group(children: flattened, op: logicalOperator)
        }
    }

    // MARK: - Produce SQL
    func toQuery() -> String {
        switch node {
        case .comparison(let key, let value, let comparison, let positive):
            if let value = value {
                let quotations = Statement().getQuotation(forValue: value)
                return "\(key) \(comparison.rawValue) \(quotations)\(value)\(quotations)"
            } else {
                return positive ? "\(key) IS NULL" : "\(key) IS NOT NULL"
            }

        case .group(let children, let op):
            let parts = children.map { "(\($0.toQuery()))" }
            return parts.joined(separator: " \(op.rawValue) ")
        }
    }
}

/** Filter in local database */
public func && (left: SundeedExpression, right: SundeedExpression) -> SundeedExpression {
    return SundeedExpression([left, right], logicalOperator: .and)
}
public func || (left: SundeedExpression, right: SundeedExpression) -> SundeedExpression {
    return SundeedExpression([left, right], logicalOperator: .or)
}
public func != (left: SundeedColumn, right: String?) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .notEqual, positive: false)
}
public func == (left: SundeedColumn, right: String?) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .equal)
}
public func != (left: SundeedColumn, right: Bool) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .notEqual, positive: false)
}
public func == (left: SundeedColumn, right: Bool) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .equal)
}
public func != (left: SundeedColumn, right: Int) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .notEqual, positive: false)
}
public func == (left: SundeedColumn, right: Int) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .equal)
}
public func >= (left: SundeedColumn, right: Int) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .greaterThanOrEqual)
}
public func > (left: SundeedColumn, right: Int) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .greaterThan)
}
public func <= (left: SundeedColumn, right: Int) -> SundeedExpression{
    return SundeedExpression(left.value, right, comparison: .lessThanOrEqual)
}
public func < (left: SundeedColumn, right: Int) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .lessThan)
}
public func != (left: SundeedColumn, right: Double) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .notEqual, positive: false)
}
public func == (left: SundeedColumn, right: Double) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .equal)
}
public func >= (left: SundeedColumn, right: Double) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .greaterThanOrEqual)
}
public func > (left: SundeedColumn, right: Double) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .greaterThan)
}
public func <= (left: SundeedColumn, right: Double) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .lessThanOrEqual)
}
public func < (left: SundeedColumn, right: Double) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .lessThan)
}
public func != (left: SundeedColumn, right: Float) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .notEqual, positive: false)
}
public func == (left: SundeedColumn, right: Float) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .equal)
}
public func >= (left: SundeedColumn, right: Float) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .greaterThanOrEqual)
}
public func > (left: SundeedColumn, right: Float) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .greaterThan)
}
public func <= (left: SundeedColumn, right: Float) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .lessThanOrEqual)
}
public func < (left: SundeedColumn, right: Float) -> SundeedExpression {
    return SundeedExpression(left.value, right, comparison: .lessThanOrEqual)
}
public func != (left: SundeedColumn, right: Date) -> SundeedExpression {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: .notEqual, positive: false)
}
public func == (left: SundeedColumn, right: Date) -> SundeedExpression {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: .equal)
}
public func >= (left: SundeedColumn, right: Date) -> SundeedExpression {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: .greaterThanOrEqual)
}
public func > (left: SundeedColumn, right: Date) -> SundeedExpression {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: .greaterThan)
}
public func <= (left: SundeedColumn, right: Date) -> SundeedExpression {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: .lessThanOrEqual)
}
public func < (left: SundeedColumn, right: Date) -> SundeedExpression {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: .lessThan)
}
