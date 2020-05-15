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
    var employer: EmployerForTesting? = EmployerForTesting()
    
    override func setUp() {
        employer?.fillData()
        employer?.save()
    }
    override class func tearDown() {
        SundeedQLite.deleteDatabase()
    }
    
    func testDeleting() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            do {
                if try !(self.employer?.delete() ?? false) {
                    XCTFail("Couldn't delete class")
                } else {
                    
                }
            } catch {
                XCTFail("Couldn't delete class")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                EmployerForTesting.retrieve(completion: { (allEmployers) in
                    XCTAssert(allEmployers.isEmpty)
                    expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 6.0)
    }
    
    func testRetrieve() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            EmployerForTesting.retrieve(completion: { (allEmployers) in
                guard let employer = allEmployers.first else {
                    XCTFail("Couldn't Retrieve From Database")
                    return
                }
                self.checkEmployer(employer)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 4.0)
    }
    
    func testRetrieveWithFilter() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "string",
                                        completion: { (allEmployers) in
                                            guard let employer = allEmployers.first else {
                                                XCTFail("Couldn't Retrieve From Database")
                                                return
                                            }
                                            self.checkEmployer(employer)
                                            expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveWithWrongFilter() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "ABCD",
                                        completion: { (allEmployers) in
                                            XCTAssertEqual(allEmployers.count, 0)
                                            expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGlobalUpdate() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            do {
                if try !EmployerForTesting.update(changes: SundeedColumn("optionalString") <~ "test",
                                                  withFilter: SundeedColumn("string") == "string") {
                    XCTFail("Couldn't update Global Employer Table")
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "string",
                                                    completion: { (allEmployers) in
                                                        guard let employer = allEmployers.first else {
                                                            XCTFail("Couldn't Retrieve From Database")
                                                            return
                                                        }
                                                        XCTAssert(employer.optionalString == "test")
                                                        expectation.fulfill()
                        })
                    }
                }
            } catch {
                XCTFail("Couldn't update Global Employer Table \(error)")
            }
        }
        wait(for: [expectation], timeout: 8.0)
    }
    
    func testUpdate() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.employer?.optionalString = "test"
            self.employer?.object.firstName = "testtt"
            self.employer?.update(columns: SundeedColumn("optionalString"),
                                  SundeedColumn("object"))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                EmployerForTesting.retrieve(completion: { (allEmployers) in
                                                guard let employer1 = allEmployers.first else {
                                                    XCTFail("Couldn't Retrieve From Database")
                                                    return
                                                }
                                                XCTAssert(employer1.optionalString == "test")
                                                XCTAssert(employer1.object.firstName == "testtt")
                                                expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testArraySaving() {
        guard let employer = employer else {
            XCTFail("Employer is nil")
            return
        }
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string1"
        employer2.integer = 2
        [employer2,employer].save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            EmployerForTesting.retrieve(completion: { (allEmployers) in
                                            guard let employer1 = allEmployers.first else {
                                                XCTFail("Couldn't Retrieve From Database")
                                                return
                                            }
                self.checkEmployer(allEmployers[1])
                XCTAssert(employer1.integer == 2)
                XCTAssert(employer1.string == "string1")
                                            expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 1)
        
    }
    
    func testSubscript() {
        guard let employer = employer, let string = employer["string"] as? String else {
            XCTFail("Employer is nil")
            return
        }
        XCTAssertEqual(string, "string")
    }
    
    func testWrongSubscript() {
        guard let employer = employer else {
            XCTFail("Employer is nil")
            return
        }
        let string = employer["wrong"] as? String
        XCTAssertNil(string)
    }
    
    private func checkEmployer(_ employer: EmployerForTesting) {
        XCTAssertEqual(employer.type, Type.manager)
        XCTAssertEqual(employer.string, "string")
        XCTAssertEqual(employer.optionalString, "optionalString")
        XCTAssertNotNil(employer.object)
        XCTAssertNotNil(employer.optionalObject)
        XCTAssertEqual(employer.integer, 1)
        XCTAssertEqual(employer.optionalInteger, 2)
        XCTAssertEqual(employer.double, 3.0)
        XCTAssertEqual(employer.optionalDouble, 4.0)
        XCTAssertEqual(employer.float, 5.0)
        XCTAssertEqual(employer.optionalFloat, 6.0)
        XCTAssertEqual(employer.bool, true)
        XCTAssertEqual(employer.optionalBool, true)
        XCTAssertNotNil(employer.date)
        XCTAssertNotNil(employer.optionalDate)
        XCTAssertNotNil(employer.image)
        XCTAssertNotNil(employer.optionalImage)
        XCTAssertEqual(employer.arrayOfStrings, ["string1", "string2"])
        XCTAssertEqual(employer.arrayOfOptionalStrings, ["string3"])
        XCTAssertEqual(employer.optionalArrayOfStrings, ["string4", "string6"])
        XCTAssertEqual(employer.optionalArrayOfOptionalStrings, ["string7"])
        XCTAssertNotNil(employer.arrayOfObjects)
        XCTAssertNotNil(employer.arrayOfOptionalObjects)
        XCTAssertNotNil(employer.optionalArrayOfObjects)
        XCTAssertNotNil(employer.optionalArrayOfOptionalObjects)
        XCTAssertEqual(employer.arrayOfIntegers[0], 1)
        XCTAssertEqual(employer.arrayOfIntegers[1], 2)
        XCTAssertEqual(employer.arrayOfOptionalIntegers[0], 2)
        XCTAssertEqual(employer.optionalArrayOfIntegers?[0], 1)
        XCTAssertEqual(employer.optionalArrayOfIntegers?[1], 2)
        XCTAssertEqual(employer.optionalArrayOfOptionalIntegers?[0], 2)
        XCTAssertEqual(employer.arrayOfDoubles[0], 3.0)
        XCTAssertEqual(employer.arrayOfDoubles[1], 4.0)
        XCTAssertEqual(employer.arrayOfOptionalDoubles[0], 4.0)
        XCTAssertEqual(employer.optionalArrayOfDoubles?[0], 3.0)
        XCTAssertEqual(employer.optionalArrayOfDoubles?[1], 4.0)
        XCTAssertEqual(employer.optionalArrayOfOptionalDoubles?[0], 4.0)
        XCTAssertEqual(employer.arrayOfFloats[0], 5.0)
        XCTAssertEqual(employer.arrayOfFloats[1], 6.0)
        XCTAssertEqual(employer.arrayOfOptionalFloats[0], 6.0)
        XCTAssertEqual(employer.optionalArrayOfFloats?[0], 5.0)
        XCTAssertEqual(employer.optionalArrayOfFloats?[1], 6.0)
        XCTAssertEqual(employer.optionalArrayOfOptionalFloats?[0], 6.0)
        XCTAssertTrue(employer.arrayOfBools[0])
        XCTAssertFalse(employer.arrayOfBools[1])
        XCTAssertTrue(employer.arrayOfOptionalBools[0] ?? false)
        XCTAssertTrue(employer.optionalArrayOfBools?[0] ?? false)
        XCTAssertFalse(employer.optionalArrayOfBools?[1] ?? true)
        XCTAssertTrue(employer.optionalArrayOfOptionalBools?[0] ?? false)
        XCTAssertNotNil(employer.arrayOfDates)
        XCTAssertNotNil(employer.arrayOfOptionalDates)
        XCTAssertNotNil(employer.optionalArrayOfDates)
        XCTAssertNotNil(employer.optionalArrayOfOptionalDates)
        XCTAssertNotNil(employer.arrayOfImages)
        XCTAssertNotNil(employer.arrayOfOptionalImages)
        XCTAssertNotNil(employer.optionalArrayOfImages)
        XCTAssertNotNil(employer.optionalArrayOfOptionalImages)
        XCTAssertNil(employer.nilString)
        XCTAssertNil(employer.nilObject)
        XCTAssertNil(employer.nilInteger)
        XCTAssertNil(employer.nilDouble)
        XCTAssertNil(employer.nilFloat)
        XCTAssertNil(employer.nilBool)
        XCTAssertNil(employer.nilDate)
        XCTAssertNil(employer.nilImage)
        XCTAssertNil(employer.nilArrayOfStrings)
        XCTAssertNil(employer.nilArrayOfOptionalStrings)
        XCTAssertNil(employer.nilArrayOfObjects)
        XCTAssertNil(employer.nilArrayOfOptionalObjects)
        XCTAssertNil(employer.nilArrayOfDoubles)
        XCTAssertNil(employer.nilArrayOfOptionalDoubles)
        XCTAssertNil(employer.nilArrayOfFloats)
        XCTAssertNil(employer.nilArrayOfOptionalFloats)
        XCTAssertNil(employer.nilArrayOfBools)
        XCTAssertNil(employer.nilArrayOfOptionalBools)
        XCTAssertNil(employer.nilArrayOfDates)
        XCTAssertNil(employer.nilArrayOfOptionalDates)
        XCTAssertNil(employer.nilArrayOfImages)
        XCTAssertNil(employer.nilArrayOfOptionalImages)
        XCTAssertEqual(employer.emptyArrayOfStrings.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalStrings.count, 0)
        XCTAssertEqual(employer.emptyArrayOfObjects.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalObjects.count, 0)
        XCTAssertEqual(employer.emptyArrayOfDoubles.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalDoubles.count, 0)
        XCTAssertEqual(employer.emptyArrayOfFloats.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalFloats.count, 0)
        XCTAssertEqual(employer.emptyArrayOfBools.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalBools.count, 0)
        XCTAssertEqual(employer.emptyArrayOfDates.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalDates.count, 0)
        XCTAssertEqual(employer.emptyArrayOfImages.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalImages.count, 0)
    }
}
