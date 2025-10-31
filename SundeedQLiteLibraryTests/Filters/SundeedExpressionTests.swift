//
//  SundeedExpressionTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class SundeedExpressionTests: XCTestCase {
    func testEqualStringWithoutQuote() {
        let expr = SundeedColumn("name") == "alice"
        XCTAssertEqual(expr.toQuery(), "name = 'alice'")
    }
    
    func testEqualStringWithSingleQuote() {
        let expr = SundeedColumn("name") == "a'b"
        XCTAssertEqual(expr.toQuery(), "name = \"a'b\"")
    }
    
    func testNilPositiveAndNegative() {
        let isNull = SundeedColumn("note") == nil
        XCTAssertEqual(isNull.toQuery(), "note IS NULL")
        let notNull = SundeedColumn("note") != nil
        XCTAssertEqual(notNull.toQuery(), "note IS NOT NULL")
    }
    
    func testNumericComparisons() {
        XCTAssertEqual((SundeedColumn("age") >= 18).toQuery(), "age >= 18")
        XCTAssertEqual((SundeedColumn("age") > 18).toQuery(), "age > 18")
        XCTAssertEqual((SundeedColumn("age") <= 18).toQuery(), "age <= 18")
        XCTAssertEqual((SundeedColumn("age") < 18).toQuery(), "age < 18")
        XCTAssertEqual((SundeedColumn("age") == 18).toQuery(), "age = 18")
        XCTAssertEqual((SundeedColumn("age") != 18).toQuery(), "age <> 18")
    }
    
    func testGroupingAndOr() {
        let a = SundeedColumn("a") == 1
        let b = SundeedColumn("b") == 2
        let c = SundeedColumn("c") == 3
        let andGroup = a && b
        let orGroup = andGroup || c
        XCTAssertEqual(andGroup.toQuery(), "(a = 1) AND (b = 2)")
        XCTAssertEqual(orGroup.toQuery(), "((a = 1) AND (b = 2)) OR (c = 3)")
    }
    
    func testStringNotEqual() {
        XCTAssertEqual((SundeedColumn("name") != "alice").toQuery(), "name <> 'alice'")
        XCTAssertEqual((SundeedColumn("name") != nil).toQuery(), "name IS NOT NULL")
    }
    
    func testBoolOperators() {
        XCTAssertEqual((SundeedColumn("active") == true).toQuery(), "active = true")
        XCTAssertEqual((SundeedColumn("active") == false).toQuery(), "active = false")
        XCTAssertEqual((SundeedColumn("active") != true).toQuery(), "active <> true")
        XCTAssertEqual((SundeedColumn("active") != false).toQuery(), "active <> false")
    }
    
    func testDoubleOperators() {
        XCTAssertEqual((SundeedColumn("price") == 19.99).toQuery(), "price = 19.99")
        XCTAssertEqual((SundeedColumn("price") != 19.99).toQuery(), "price <> 19.99")
        XCTAssertEqual((SundeedColumn("price") >= 19.99).toQuery(), "price >= 19.99")
        XCTAssertEqual((SundeedColumn("price") > 19.99).toQuery(), "price > 19.99")
        XCTAssertEqual((SundeedColumn("price") <= 19.99).toQuery(), "price <= 19.99")
        XCTAssertEqual((SundeedColumn("price") < 19.99).toQuery(), "price < 19.99")
    }
    
    func testFloatOperators() {
        XCTAssertEqual((SundeedColumn("score") == 3.14 as Float).toQuery(), "score = 3.14")
        XCTAssertEqual((SundeedColumn("score") != 3.14 as Float).toQuery(), "score <> 3.14")
        XCTAssertEqual((SundeedColumn("score") >= 3.14 as Float).toQuery(), "score >= 3.14")
        XCTAssertEqual((SundeedColumn("score") > 3.14 as Float).toQuery(), "score > 3.14")
        XCTAssertEqual((SundeedColumn("score") <= 3.14 as Float).toQuery(), "score <= 3.14")
        XCTAssertEqual((SundeedColumn("score") < 3.14 as Float).toQuery(), "score <= 3.14")
    }
    
    func testDateOperators() {
        let date = Date(timeIntervalSince1970: 1000)
        let expectedTime = 1000.0 * 1000.0
        
        XCTAssertEqual((SundeedColumn("created") == date).toQuery(), "created = \(expectedTime)")
        XCTAssertEqual((SundeedColumn("created") != date).toQuery(), "created <> \(expectedTime)")
        XCTAssertEqual((SundeedColumn("created") >= date).toQuery(), "created >= \(expectedTime)")
        XCTAssertEqual((SundeedColumn("created") > date).toQuery(), "created > \(expectedTime)")
        XCTAssertEqual((SundeedColumn("created") <= date).toQuery(), "created <= \(expectedTime)")
        XCTAssertEqual((SundeedColumn("created") < date).toQuery(), "created < \(expectedTime)")
    }
    
    func testGroupFlatteningSameOperator() {
        let a = SundeedColumn("a") == 1
        let b = SundeedColumn("b") == 2
        let c = SundeedColumn("c") == 3
        let d = SundeedColumn("d") == 4
        
        let group1 = a && b
        let group2 = c && d
        let combined = group1 && group2
        
        XCTAssertEqual(combined.toQuery(), "(a = 1) AND (b = 2) AND (c = 3) AND (d = 4)")
    }
    
    func testGroupFlatteningDifferentOperators() {
        let a = SundeedColumn("a") == 1
        let b = SundeedColumn("b") == 2
        let c = SundeedColumn("c") == 3
        
        let andGroup = a && b
        let orGroup = andGroup || c
        
        XCTAssertEqual(orGroup.toQuery(), "((a = 1) AND (b = 2)) OR (c = 3)")
    }
    
    func testSingleExpressionGroup() {
        let a = SundeedColumn("a") == 1
        let singleGroup = SundeedExpression([a], logicalOperator: .and)
        XCTAssertEqual(singleGroup.toQuery(), "a = 1")
    }
}


