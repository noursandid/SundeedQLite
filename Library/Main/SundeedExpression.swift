//
//  SundeedExpression.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 30/09/2025.
//  Copyright © 2025 LUMBERCODE. All rights reserved.
//

import Foundation

/** SundeedColumn("columnName") == "value" */
public struct SundeedExpression<Bool>: @unchecked Sendable {
    public var template: String
    public var bindings: Any?
    public var comparison: String = "="
    public init(_ template: String, _ bindings: Any?, comparison: String = "=") {
        self.template = template
        self.bindings = bindings
        self.comparison = comparison
    }
    public func toQuery() -> String {
        if let bindings {
            let quotations = Statement().getQuotation(forValue: bindings)
            return "\(self.template) \(self.comparison) \(quotations)\(bindings)\(quotations)"
        } else {
            return "\(self.template) IS NULL"
        }
    }
}

/** Filter in local database */
public func == (left: SundeedColumn, right: String?) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: "=")
}
public func == (left: SundeedColumn, right: Int) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: "=")
}
public func >= (left: SundeedColumn, right: Int) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: ">=")
}
public func > (left: SundeedColumn, right: Int) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: ">")
}
public func <= (left: SundeedColumn, right: Int) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: "<=")
}
public func < (left: SundeedColumn, right: Int) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: "<")
}
public func == (left: SundeedColumn, right: Double) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: "=")
}
public func >= (left: SundeedColumn, right: Double) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: ">=")
}
public func > (left: SundeedColumn, right: Double) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: ">")
}
public func <= (left: SundeedColumn, right: Double) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: "<=")
}
public func < (left: SundeedColumn, right: Double) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: "<")
}
public func == (left: SundeedColumn, right: Float) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: "=")
}
public func >= (left: SundeedColumn, right: Float) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: ">=")
}
public func > (left: SundeedColumn, right: Float) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: ">")
}
public func <= (left: SundeedColumn, right: Float) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: "<=")
}
public func < (left: SundeedColumn, right: Float) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right, comparison: "<")
}
public func == (left: SundeedColumn, right: Date) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: "=")
}
public func >= (left: SundeedColumn, right: Date) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: ">=")
}
public func > (left: SundeedColumn, right: Date) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: ">")
}
public func <= (left: SundeedColumn, right: Date) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: "<=")
}
public func < (left: SundeedColumn, right: Date) -> SundeedExpression<Bool> {
    return SundeedExpression(left.value, right.timeIntervalSince1970*1000, comparison: "<")
}
