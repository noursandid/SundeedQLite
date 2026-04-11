//
//  SundeedExpressionEdgeCaseTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class SundeedExpressionEdgeCaseTests: XCTestCase {

    // MARK: - Boolean generates valid SQL
    func testBoolTrueQuery() {
        let expr = SundeedColumn("active") == true
        XCTAssertEqual(expr.toQuery(), "active = true")
    }

    func testBoolFalseQuery() {
        let expr = SundeedColumn("active") == false
        XCTAssertEqual(expr.toQuery(), "active = false")
    }

    func testBoolNotEqualTrue() {
        let expr = SundeedColumn("active") != true
        XCTAssertEqual(expr.toQuery(), "active <> true")
    }

    func testBoolNotEqualFalse() {
        let expr = SundeedColumn("active") != false
        XCTAssertEqual(expr.toQuery(), "active <> false")
    }

    // MARK: - Float < operator (was previously returning <=)
    func testFloatLessThan() {
        let expr = SundeedColumn("score") < 3.14 as Float
        XCTAssertEqual(expr.toQuery(), "score < 3.14")
    }

    func testFloatLessThanOrEqual() {
        let expr = SundeedColumn("score") <= 3.14 as Float
        XCTAssertEqual(expr.toQuery(), "score <= 3.14")
    }

    func testFloatLessThanNotEqualToLessThanOrEqual() {
        let lt = (SundeedColumn("x") < 5.0 as Float).toQuery()
        let lte = (SundeedColumn("x") <= 5.0 as Float).toQuery()
        XCTAssertNotEqual(lt, lte, "< and <= should produce different SQL")
    }

    // MARK: - Empty and nil edge cases
    func testEmptyStringFilter() {
        let expr = SundeedColumn("name") == ""
        XCTAssertEqual(expr.toQuery(), "name = ''")
    }

    func testNilStringFilter() {
        let nilStr: String? = nil
        let expr = SundeedColumn("name") == nilStr
        XCTAssertEqual(expr.toQuery(), "name IS NULL")
    }

    func testNilStringNotEqual() {
        let nilStr: String? = nil
        let expr = SundeedColumn("name") != nilStr
        XCTAssertEqual(expr.toQuery(), "name IS NOT NULL")
    }

    // MARK: - Zero values
    func testIntZero() {
        let expr = SundeedColumn("count") == 0
        XCTAssertEqual(expr.toQuery(), "count = 0")
    }

    func testDoubleZero() {
        let expr = SundeedColumn("amount") == 0.0
        XCTAssertEqual(expr.toQuery(), "amount = 0.0")
    }

    // MARK: - Negative values
    func testNegativeInt() {
        let expr = SundeedColumn("temp") == -10
        XCTAssertEqual(expr.toQuery(), "temp = -10")
    }

    func testNegativeDouble() {
        let expr = SundeedColumn("temp") < -5.5
        XCTAssertEqual(expr.toQuery(), "temp < -5.5")
    }

    // MARK: - Complex nested expressions
    func testDeeplyNestedExpression() {
        let a = SundeedColumn("x") == 1
        let b = SundeedColumn("y") == 2
        let c = SundeedColumn("z") == 3
        let d = SundeedColumn("w") == 4
        let result = (a && b) || (c && d)
        let query = result.toQuery()
        XCTAssertTrue(query.contains("OR"))
        XCTAssertTrue(query.contains("AND"))
    }

    // MARK: - needsSeparator renamed correctly
    func testNeedsSeparatorAtLastIndex() {
        let s = Statement()
        XCTAssertFalse(s.needsSeparator(at: 0, in: [1]))
    }

    func testNeedsSeparatorNotAtLastIndex() {
        let s = Statement()
        XCTAssertTrue(s.needsSeparator(at: 0, in: [1, 2]))
    }
}
