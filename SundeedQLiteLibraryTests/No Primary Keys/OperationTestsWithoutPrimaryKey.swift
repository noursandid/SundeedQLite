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
    }
    
    override func tearDown() {
        SundeedQLite.deleteDatabase()
        noPrimary = nil
        employerWithNoPrimary = nil
    }
    
    
    func testSaveEmployerWithNoPrimary() {
        let expectation = XCTestExpectation(description: "SaveEmployerWithNoPrimary")
        employerWithNoPrimary?.save {
            EmployerWithNoPrimaryForTesting
                .retrieve(completion: { (employers) in
                    XCTAssert(employers.isEmpty)
                    expectation.fulfill()
                    _ = try? self.employerWithNoPrimary?.delete()
                })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testRetrieve() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        noPrimary?.save {
            ClassWithNoPrimary.retrieve(completion: { (noPrimaries) in
                guard let noPrimary = noPrimaries.first else {
                    XCTFail("Couldn't Retrieve From Database")
                    return
                }
                XCTAssertEqual(noPrimary.firstName, "TestFirst")
                XCTAssertEqual(noPrimary.lastName, "TestLast")
                expectation.fulfill()
                _ = try? self.noPrimary?.delete()
            })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testRetrieveWithFilter() {
        let expectation = XCTestExpectation(description: "RetrieveWithFilter")
        noPrimary?.save {
            ClassWithNoPrimary
                .retrieve(withFilter: SundeedColumn("firstName") == "TestFirst",
                          completion: { (noPrimaries) in
                            guard let noPrimary = noPrimaries.first else {
                                XCTFail("Couldn't Retrieve From Database")
                                return
                            }
                            XCTAssertEqual(noPrimary.firstName, "TestFirst")
                            XCTAssertEqual(noPrimary.lastName, "TestLast")
                            expectation.fulfill()
                            _ = try? self.noPrimary?.delete()
                })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testUpdate() {
        let expectation = XCTestExpectation(description: "Update")
        noPrimary?.save {
            do {
                self.noPrimary?.firstName = "TestFirstUpdated"
                try self.noPrimary?.update(columns: SundeedColumn("firstName"))
                XCTFail("It shouldn't be able to update")
                expectation.fulfill()
            } catch {
                expectation.fulfill()
                _ = try? self.noPrimary?.delete()
            }
            
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testGlobalUpdate() {
        let expectation = XCTestExpectation(description: "GlobalUpdate")
        noPrimary?.save {
            do {
                try ClassWithNoPrimary.update(changes: SundeedColumn("firstName") <~ "TestFirstUpdated")
                XCTFail("It shouldn't be able to update")
                expectation.fulfill()
            } catch {
                expectation.fulfill()
                _ = try? self.noPrimary?.delete()
            }
            
        }
        wait(for: [expectation], timeout: 1)
    }
    
}
