//
//  Listeners.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class Listeners: XCTestCase {
    var employer: EmployerForTesting? = EmployerForTesting()
    
    override func setUp() {
        EmployerForTesting.delete()
        EmployeeForTesting.delete()
        employer?.fillData()
    }
    
    override class func tearDown() {
//        SundeedQLite.deleteDatabase()
        UserDefaults.standard.removeObject(forKey: Sundeed.shared.shouldCopyDatabaseToFilePathKey)
    }
    
    func testSpecificOnAllEventsListener() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        let listener = self.employer?.onAllEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        employer?.save()
        wait(for: [expectation], timeout: 0.1)
        listener?.stop()
    }
    
    func testSpecificOnSaveListener() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        let listener = self.employer?.onSaveEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        employer?.save()
        wait(for: [expectation], timeout: 0.1)
        listener?.stop()
    }
    
    func testSpecificOnUpdateListener() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        let listener = self.employer?.onUpdateEvents({ (object) in
            XCTAssertEqual(object.string, "test")
            expectation.fulfill()
        })
        employer?.string = "test"
        try? employer?.update(columns: SundeedColumn("string"))
        wait(for: [expectation], timeout: 1)
        listener?.stop()
    }
    
    func testSpecificOnRetrieveListener() {
        employer?.save()
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        let listener = self.employer?.onRetrieveEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            EmployerForTesting.retrieve(completion: { _ in })
        }
        wait(for: [expectation], timeout: 1)
        listener?.stop()
    }
    
    func testSpecificOnDeleteListener() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        let listener = self.employer?.onDeleteEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        let _ = try? employer?.delete()
        wait(for: [expectation], timeout: 0.1)
        listener?.stop()
    }
    
    
    func testGlobalOnAllEventsListener() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        let listener = EmployerForTesting.onAllEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        employer?.save()
        wait(for: [expectation], timeout: 0.1)
        listener.stop()
    }
    
    func testGlobalOnSaveListener() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        let listener = EmployerForTesting.onSaveEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        employer?.save()
        wait(for: [expectation], timeout: 0.1)
        listener.stop()
    }
    
    func testGlobalOnUpdateListener() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        let listener = EmployerForTesting.onUpdateEvents({ (object) in
            XCTAssertEqual(object.string, "test")
            expectation.fulfill()
        })
        employer?.string = "test"
        try? employer?.update(columns: SundeedColumn("string"))
        wait(for: [expectation], timeout: 1)
        listener.stop()
    }
    
    func testGlobalOnRetrieveListener() {
        employer?.save()
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        let listener = EmployerForTesting.onRetrieveEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            EmployerForTesting.retrieve(completion: { _ in })
        }
        wait(for: [expectation], timeout: 2)
        listener.stop()
    }
    
    func testGlobalOnDeleteListener() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        let listener = EmployerForTesting.onDeleteEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        let _ = try? employer?.delete()
        wait(for: [expectation], timeout: 0.1)
        listener.stop()
    }
}
