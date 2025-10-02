//
//  SundeedLog.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 02/10/2025.
//  Copyright © 2025 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class SundeedLoggerTests: XCTestCase {
    override func setUp() {
        SundeedLogger.testingDidPrint = false
    }
    
    func testDebugLogWithVerboseLevel() {
        SundeedLogger.logLevel = .verbose
        SundeedLogger.debug("")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }
    
    func testInfoLogWithVerboseLevel() {
        SundeedLogger.logLevel = .verbose
        SundeedLogger.info("")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }
    
    func testErrorLogWithVerboseLevel() {
        SundeedLogger.logLevel = .verbose
        SundeedLogger.info("")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }
    
    func testDebugLogWithInfoLevel() {
        SundeedLogger.logLevel = .info
        SundeedLogger.debug("")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }
    
    func testInfoLogWithInfoLevel() {
        SundeedLogger.logLevel = .info
        SundeedLogger.info("")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }
    
    func testErrorLogWithInfoLevel() {
        SundeedLogger.logLevel = .info
        SundeedLogger.info("")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }
    
    func testDebugLogWithErrorLevel() {
        SundeedLogger.logLevel = .error
        SundeedLogger.debug("")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }
    
    func testInfoLogWithErrorLevel() {
        SundeedLogger.logLevel = .error
        SundeedLogger.info("")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }
    
    func testErrorLogWithErrorLevel() {
        SundeedLogger.logLevel = .error
        SundeedLogger.error("")
        XCTAssertTrue(SundeedLogger.testingDidPrint)
    }
    
    func testDebugLogWithProductionLevel() {
        SundeedLogger.logLevel = .production
        SundeedLogger.debug("")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }
    
    func testInfoLogWithProductionLevel() {
        SundeedLogger.logLevel = .production
        SundeedLogger.info("")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }
    
    func testErrorLogWithProductionLevel() {
        SundeedLogger.logLevel = .production
        SundeedLogger.info("")
        XCTAssertFalse(SundeedLogger.testingDidPrint)
    }
}
