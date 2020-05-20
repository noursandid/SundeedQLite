//
//  OperationTestsWithoutPrimaryKey.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/16/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class OperationTestsWithoutPrimaryKey: XCTestCase {
    var noPrimary: ClassWithNoPrimary?
    var employerWithNoPrimary: EmployerWithNoPrimaryForTesting?
    
    
    override func setUp() {
        employerWithNoPrimary = EmployerWithNoPrimaryForTesting()
        employerWithNoPrimary?.fillData()
        noPrimary = ClassWithNoPrimary()
        noPrimary?.fillData()
        noPrimary?.save()
    }
    
    override func tearDown() {
        SundeedQLite.deleteDatabase()
        noPrimary = nil
        employerWithNoPrimary = nil
    }
    
    
    func testSaveEmployerWithNoPrimary() {
        employerWithNoPrimary?.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            EmployerWithNoPrimaryForTesting
                .retrieve(completion: { (employers) in
                    XCTAssert(employers.isEmpty)
                    expectation.fulfill()
                })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testRetrieve() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            ClassWithNoPrimary.retrieve(completion: { (noPrimaries) in
                guard let noPrimary = noPrimaries.first else {
                    XCTFail("Couldn't Retrieve From Database")
                    return
                }
                XCTAssert(noPrimary.firstName == "TestFirst")
                XCTAssert(noPrimary.lastName == "TestLast")
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testRetrieveWithFilter() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithNoPrimary.retrieve(withFilter: SundeedColumn("firstName") == "TestFirst",
                                        completion: { (noPrimaries) in
                                            guard let noPrimary = noPrimaries.first else {
                                                XCTFail("Couldn't Retrieve From Database")
                                                return
                                            }
                                            XCTAssert(noPrimary.firstName == "TestFirst")
                                            XCTAssert(noPrimary.lastName == "TestLast")
                                            expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testUpdate() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            do {
                self.noPrimary?.firstName = "TestFirstUpdated"
                try self.noPrimary?.update(columns: SundeedColumn("firstName"))
                XCTFail("It shouldn't be able to update")
            } catch {
                expectation.fulfill()
            }
            
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testGlobalUpdate() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            do {
                try ClassWithNoPrimary.update(changes: SundeedColumn("firstName") <~ "TestFirstUpdated")
                XCTFail("It shouldn't be able to update")
            } catch {
                expectation.fulfill()
            }
            
        }
        wait(for: [expectation], timeout: 1)
    }
    
}
