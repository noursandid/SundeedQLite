//
//  SundeedExpressionAdditionalTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class SundeedExpressionAdditionalTests: XCTestCase {
    // MARK: - OR flattening
    func testOrFlatteningSameOperator() {
        let a = SundeedColumn("a") == 1
        let b = SundeedColumn("b") == 2
        let c = SundeedColumn("c") == 3
        let d = SundeedColumn("d") == 4
        let group1 = a || b
        let group2 = c || d
        let combined = group1 || group2
        XCTAssertEqual(combined.toQuery(), "(a = 1) OR (b = 2) OR (c = 3) OR (d = 4)")
    }

    // MARK: - Empty group
    func testEmptyExpressionsGroup() {
        let group = SundeedExpression([], logicalOperator: .and)
        _ = group.toQuery() // should not crash
    }

    // MARK: - String comparisons with double quotes
    func testStringWithDoubleQuote() {
        let expr = SundeedColumn("name") == "it's"
        XCTAssertEqual(expr.toQuery(), "name = \"it's\"")
    }

    // MARK: - Mixed OR and AND nesting
    func testMixedOrAndNesting() {
        let a = SundeedColumn("x") == 1
        let b = SundeedColumn("y") == 2
        let c = SundeedColumn("z") == 3
        let orGroup = a || b
        let result = orGroup && c
        XCTAssertEqual(result.toQuery(), "((x = 1) OR (y = 2)) AND (z = 3)")
    }

    // MARK: - String equal nil
    func testStringEqualNil() {
        let nilStr: String? = nil
        let expr = SundeedColumn("col") == nilStr
        XCTAssertEqual(expr.toQuery(), "col IS NULL")
    }

    // MARK: - String not equal with value
    func testStringNotEqualWithSingleQuoteValue() {
        let expr = SundeedColumn("col") != "it's"
        XCTAssertEqual(expr.toQuery(), "col <> \"it's\"")
    }

    // MARK: - Int equal and not equal
    func testIntEqual() {
        let expr = SundeedColumn("num") == 0
        XCTAssertEqual(expr.toQuery(), "num = 0")
    }

    func testIntNotEqual() {
        let expr = SundeedColumn("num") != 0
        XCTAssertEqual(expr.toQuery(), "num <> 0")
    }
}
