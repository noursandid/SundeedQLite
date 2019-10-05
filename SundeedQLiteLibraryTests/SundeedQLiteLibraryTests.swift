//
//  SundeedQLiteLibraryTests.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 10/5/19.
//  Copyright © 2019 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class SundeedQLiteLibraryTests: XCTestCase {
    var employer: Employer? = Employer()
    
    override func setUp() {
        let employee = Employee()
        employee.firstName = "Nour"
        employer?.id = "ABCD-1234-EFGH-5678"
        employer?.fullName = "Nour Sandid"
        employer?.employees = [employee]
        
        employer?.save()
    }
    
    override func tearDown() {
        employer = nil
        do {
            if try !Employer.delete() {
                XCTFail("Unable To Delete")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSaving() {
        save()
    }
    
    func testDelete() {
        do {
            if try !(employer?.delete() ?? false) {
                XCTFail("Unable To Delete")
            } else {
                let expectation = XCTestExpectation(description: "Retrieve Employer")
                Employer.retrieve(withFilter: SundeedColumn("id") == "ABCD",
                                  completion: { (allEmployers) in
                                    XCTAssertTrue(allEmployers.count == 0)
                                    XCTAssertNil(allEmployers.first?.fullName)
                                    expectation.fulfill()
                })
                wait(for: [expectation], timeout: 2.0)
                save()
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    
    func testRetrieve() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            Employer.retrieve(completion: { (allEmployers) in
                XCTAssertTrue(allEmployers.count > 0)
                XCTAssertNotNil(allEmployers.first?.fullName)
                guard let fullName = allEmployers.first?.fullName else {
                    XCTFail("Couldn't Retrieve Employer")
                    return
                }
                print(fullName)
                XCTAssertEqual(fullName, "Nour Sandid")
                XCTAssertNotNil(allEmployers.first?.employees?.first?.firstName)
                guard let employeeFirstName = allEmployers.first?.employees?.first?.firstName else {
                    XCTFail("Couldn't Retrieve Employer")
                    return
                }
                XCTAssertEqual(employeeFirstName, "Nour")
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveWithFilter() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            Employer.retrieve(withFilter: SundeedColumn("id") == "ABCD-1234-EFGH-5678",
                              completion: { (allEmployers) in
                                XCTAssertTrue(allEmployers.count > 0)
                                XCTAssertNotNil(allEmployers.first?.fullName)
                                guard let fullName = allEmployers.first?.fullName else {
                                    XCTFail("Couldn't Retrieve Employer")
                                    return
                                }
                                XCTAssertEqual(fullName, "Nour Sandid")
                                XCTAssertNotNil(allEmployers.first?.employees?.first?.firstName)
                                guard let employeeFirstName = allEmployers.first?.employees?.first?.firstName else {
                                    XCTFail("Couldn't Retrieve Employer")
                                    return
                                }
                                XCTAssertEqual(employeeFirstName, "Nour")
                                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveWithWrongFilter() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            Employer.retrieve(withFilter: SundeedColumn("id") == "ABCD",
                              completion: { (allEmployers) in
                                XCTAssertTrue(allEmployers.count == 0)
                                XCTAssertNil(allEmployers.first?.fullName)
                                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    private func save() {
        let employee = Employee()
        employee.firstName = "Nour"
        employer?.id = "ABCD-1234-EFGH-5678"
        employer?.fullName = "Nour Sandid"
        employer?.employees = [employee]
        
        employer?.save()
    }
    
    
    func testPerformanceExample() {
        self.measure {
            save()
            testRetrieve()
        }
    }
    
}
