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
        employer?.fillData()
    }
    
    override func tearDown() {
        SundeedQLite.deleteDatabase()
    }
    
    func testSpecificOnAllEventsListener() {
        let expectation = XCTestExpectation(description: "SpecificOnAllEventsListener")
        let listener = self.employer?.onAllEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        EmployerForTesting.delete {
            self.employer?.save()
        }
        wait(for: [expectation], timeout: 5)
        listener?.stop()
    }
    
    func testSpecificOnSaveListener() {
        let expectation = XCTestExpectation(description: "SpecificOnSaveListener")
        let listener = self.employer?.onSaveEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        EmployerForTesting.delete {
            self.employer?.save()
        }
        wait(for: [expectation], timeout: 5)
        listener?.stop()
    }
    
    func testSpecificOnUpdateListener() {
        let expectation = XCTestExpectation(description: "SpecificOnUpdateListener")
        let listener = self.employer?.onUpdateEvents({ (object) in
            XCTAssertEqual(object.string, "test")
            expectation.fulfill()
        })
        self.employer?.save() {
            self.employer?.string = "test"
            try? self.employer?.update(columns: SundeedColumn("string"))
        }
        wait(for: [expectation], timeout: 5)
        listener?.stop()
    }
    
    func testSpecificOnRetrieveListener() {
        let expectation = XCTestExpectation(description: "SpecificOnRetrieveListener")
        let listener = self.employer?.onRetrieveEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        EmployerForTesting.delete {
            self.employer?.save {
                EmployerForTesting.retrieve(completion: { _ in })
            }
        }
        wait(for: [expectation], timeout: 5)
        listener?.stop()
    }
    
    func testSpecificOnDeleteListener() {
        let expectation = XCTestExpectation(description: "SpecificOnDeleteListener")
        let listener = self.employer?.onDeleteEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        _ = try? employer?.delete()
        wait(for: [expectation], timeout: 5)
        listener?.stop()
    }
    
    
    func testGlobalOnAllEventsListener() {
        let expectation = XCTestExpectation(description: "GlobalOnAllEventsListener")
        let listener = EmployerForTesting.onAllEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        EmployerForTesting.delete {
            self.employer?.save()
        }
        wait(for: [expectation], timeout: 5)
        listener.stop()
    }
    
    func testGlobalOnSaveListener() {
        let expectation = XCTestExpectation(description: "GlobalOnSaveListener")
        let listener = EmployerForTesting.onSaveEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        EmployerForTesting.delete {
            self.employer?.save()
        }
        wait(for: [expectation], timeout: 5)
        listener.stop()
    }
    
    func testGlobalOnUpdateListener() {
        let expectation = XCTestExpectation(description: "GlobalOnUpdateListener")
        let listener = EmployerForTesting.onUpdateEvents({ (object) in
            XCTAssertEqual(object.string, "test")
            expectation.fulfill()
        })
        employer?.save {
            self.employer?.string = "test"
            try? self.employer?.update(columns: SundeedColumn("string"))
        }
        wait(for: [expectation], timeout: 5)
        listener.stop()
    }
    
    func testGlobalOnRetrieveListener() {
        let expectation = XCTestExpectation(description: "GlobalOnRetrieveListener")
        let listener = EmployerForTesting.onRetrieveEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        EmployerForTesting.delete {
            self.employer?.save {
                EmployerForTesting.retrieve(completion: { _ in })
            }
        }
        wait(for: [expectation], timeout: 5)
        listener.stop()
    }
    
    func testGlobalOnDeleteListener() {
        let expectation = XCTestExpectation(description: "GlobalOnDeleteListener")
        let listener = EmployerForTesting.onDeleteEvents({ (object) in
            XCTAssertEqual(object.string, "string")
            expectation.fulfill()
        })
        _ = try? self.employer?.delete()
        wait(for: [expectation], timeout: 5)
        listener.stop()
    }
}
