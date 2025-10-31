//
//  StatementHelpersTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class StatementHelpersTests: XCTestCase {
    func testGetQuotationForTypes() {
        let s = Statement()
        XCTAssertEqual(s.getQuotation(forValue: "plain"), "\'")
        XCTAssertEqual(s.getQuotation(forValue: "a'b"), "\"")
        XCTAssertEqual(s.getQuotation(forValue: 1), "")
        XCTAssertEqual(s.getQuotation(forValue: 1.0 as Double), "")
        XCTAssertEqual(s.getQuotation(forValue: 1.0 as Float), "")
        XCTAssertEqual(s.getQuotation(forValue: true), "")
        XCTAssertEqual(s.getQuotation(forValue: Date()), "")
    }
    
    func testIsLastIndex() {
        let s = Statement()
        XCTAssertFalse(s.isLastIndex(index: 0, in: [1]))
        XCTAssertTrue(s.isLastIndex(index: 0, in: [1,2]))
        XCTAssertFalse(s.isLastIndex(index: 1, in: [1,2]))
    }
}


