//
//  SundeedLogTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class SundeedLogTests: XCTestCase {
    override func setUp() {
        SundeedLogger.testingDidPrint = false
    }

    override func tearDown() {
        SundeedLogger.logLevel = .production
        SundeedLogger.testingDidPrint = false
    }

    func testDebugPrintsAtVerboseLevel() {
        SundeedLogger.logLevel = .verbose
        SundeedLogger.debug("test")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }

    func testDebugDoesNotPrintAtInfoLevel() {
        SundeedLogger.logLevel = .info
        SundeedLogger.debug("test")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }

    func testDebugDoesNotPrintAtErrorLevel() {
        SundeedLogger.logLevel = .error
        SundeedLogger.debug("test")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }

    func testDebugDoesNotPrintAtProductionLevel() {
        SundeedLogger.logLevel = .production
        SundeedLogger.debug("test")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }

    func testInfoPrintsAtVerboseLevel() {
        SundeedLogger.logLevel = .verbose
        SundeedLogger.info("test")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }

    func testInfoPrintsAtInfoLevel() {
        SundeedLogger.logLevel = .info
        SundeedLogger.info("test")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }

    func testInfoDoesNotPrintAtErrorLevel() {
        SundeedLogger.logLevel = .error
        SundeedLogger.info("test")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }

    func testErrorPrintsAtVerboseLevel() {
        SundeedLogger.logLevel = .verbose
        SundeedLogger.error("test")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }

    func testErrorPrintsAtInfoLevel() {
        SundeedLogger.logLevel = .info
        SundeedLogger.error("test")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }

    func testErrorPrintsAtErrorLevel() {
        SundeedLogger.logLevel = .error
        SundeedLogger.error("test")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }

    func testErrorDoesNotPrintAtProductionLevel() {
        SundeedLogger.logLevel = .production
        SundeedLogger.error("test")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }

    func testLogLevelRawValues() {
        XCTAssertEqual(SundeedLogLevel.verbose.rawValue, 0)
        XCTAssertEqual(SundeedLogLevel.info.rawValue, 1)
        XCTAssertEqual(SundeedLogLevel.error.rawValue, 2)
        XCTAssertEqual(SundeedLogLevel.production.rawValue, 3)
    }
}
