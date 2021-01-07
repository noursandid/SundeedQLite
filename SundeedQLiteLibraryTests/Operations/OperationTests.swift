//
//  OperationTests.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/16/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class OperationTests: XCTestCase {
    var employer: EmployerForTesting? = EmployerForTesting()
    
    override func setUp() {
        employer?.fillData()
    }
    override class func tearDown() {
        SundeedQLite.deleteDatabase()
        UserDefaults.standard
            .removeObject(forKey: Sundeed.shared.shouldCopyDatabaseToFilePathKey)
    }
    
    func testDeleting() {
        let expectation = XCTestExpectation(description: "Deleted Employer")
        employer?.save {
            do {
                if try !(self.employer?.delete(completion: {
                    EmployerForTesting.retrieve(completion: { (allEmployers) in
                        XCTAssert(allEmployers.isEmpty)
                        _ = try? self.employer?.delete()
                        expectation.fulfill()
                    })
                }) ?? false) {
                    XCTFail("Couldn't delete class")
                    expectation.fulfill()
                }
            } catch {
                XCTFail("Couldn't delete class")
                expectation.fulfill()
            }
            
        }
        wait(for: [expectation], timeout: 6.0)
    }
    
    func testDeletingAll() {
        let expectation = XCTestExpectation(description: "Deleted All Employers")
        employer?.save {
            EmployerForTesting.delete {
                EmployerForTesting.retrieve(completion: { (allEmployers) in
                    XCTAssert(allEmployers.isEmpty)
                    expectation.fulfill()
                    _ = try? self.employer?.delete()
                })
            }
        }
        wait(for: [expectation], timeout: 6.0)
    }
    
    func testRetrieve() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        employer?.save {
            EmployerForTesting.retrieve(completion: { (allEmployers) in
                guard let employer = allEmployers.first else {
                    XCTFail("Couldn't Retrieve From Database")
                    return
                }
                self.checkEmployer(employer)
                expectation.fulfill()
                _ = try? self.employer?.delete()
            })
        }
        wait(for: [expectation], timeout: 4.0)
    }
    
    func testRetrieveWithFilter() {
        let expectation = XCTestExpectation(description: "Retrieve Employer With Filter")
        employer?.save {
            EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "string",
                                        completion: { (allEmployers) in
                                            guard let employer = allEmployers.first else {
                                                XCTFail("Couldn't Retrieve From Database")
                                                return
                                            }
                                            self.checkEmployer(employer)
                                            expectation.fulfill()
                                            _ = try? self.employer?.delete()
            })
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveWithWrongFilter() {
        let expectation = XCTestExpectation(description: "Retrieve Employer With Wrong Filter")
        employer?.save {
            EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "ABCD",
                                        completion: { (allEmployers) in
                                            XCTAssertEqual(allEmployers.count, 0)
                                            expectation.fulfill()
                                            _ = try? self.employer?.delete()
            })
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveWithSortingIntAsc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer Int ASC")
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "str"
        employer2.integer = 2
        [employer!, employer2].save {
            EmployerForTesting.retrieve(orderBy: SundeedColumn("integer"),
                                        ascending: true,
                                        completion: { (allEmployers) in
                                            XCTAssertEqual(allEmployers.count, 2)
                                            let firstEmployer = allEmployers[0]
                                            let secondEmployer = allEmployers[1]
                                            self.checkEmployer(firstEmployer)
                                            XCTAssertEqual(secondEmployer.integer, 2)
                                            expectation.fulfill()
                                            _ = try? self.employer?.delete()
                                            _ = try? employer2.delete()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testRetrieveWithSortingIntDesc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer Int DESC")
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "stri"
        employer2.integer = 3
        [employer!, employer2].save {
            EmployerForTesting.retrieve(orderBy: SundeedColumn("integer"),
                                        ascending: false,
                                        completion: { (allEmployers) in
                                            XCTAssertEqual(allEmployers.count, 2)
                                            let firstEmployer = allEmployers[0]
                                            let secondEmployer = allEmployers[1]
                                            XCTAssertEqual(firstEmployer.integer, 3)
                                            self.checkEmployer(secondEmployer)
                                            expectation.fulfill()
                                            _ = try? self.employer?.delete()
                                            _ = try? employer2.delete()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testRetrieveWithSortingStringAsc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer String ASC")
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string2"
        employer2.integer = 2
        [employer!, employer2].save {
            EmployerForTesting.retrieve(orderBy: SundeedColumn("string"),
                                        ascending: true,
                                        completion: { (allEmployers) in
                                            XCTAssertEqual(allEmployers.count, 2)
                                            let firstEmployer = allEmployers[0]
                                            let secondEmployer = allEmployers[1]
                                            self.checkEmployer(firstEmployer)
                                            XCTAssertEqual(secondEmployer.integer, 2)
                                            expectation.fulfill()
                                            _ = try? self.employer?.delete()
                                            _ = try? employer2.delete()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testRetrieveWithSortingStringDesc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer String DESC")
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string3"
        employer2.integer = 3
        [employer!, employer2].save {
            EmployerForTesting
                .retrieve(orderBy: SundeedColumn("string"),
                          ascending: false,
                          completion: { (allEmployers) in
                            XCTAssertEqual(allEmployers.count, 2)
                            guard allEmployers.count == 2 else {
                                XCTFail()
                                return
                            }
                            let firstEmployer = allEmployers[0]
                            let secondEmployer = allEmployers[1]
                            XCTAssertEqual(firstEmployer.integer, 3)
                            self.checkEmployer(secondEmployer)
                            expectation.fulfill()
                            _ = try? self.employer?.delete()
                            _ = try? employer2.delete()
                })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testRetrieveWithSortingDateAsc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer Date ASC")
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string2"
        employer2.integer = 2
        employer2.date = Date().addingTimeInterval(500)
        [employer!, employer2].save {
            EmployerForTesting.retrieve(orderBy: SundeedColumn("date"),
                                        ascending: true,
                                        completion: { (allEmployers) in
                                            XCTAssertEqual(allEmployers.count, 2)
                                            let firstEmployer = allEmployers[0]
                                            let secondEmployer = allEmployers[1]
                                            self.checkEmployer(firstEmployer)
                                            XCTAssertEqual(secondEmployer.integer, 2)
                                            expectation.fulfill()
                                            _ = try? self.employer?.delete()
                                            _ = try? employer2.delete()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testRetrieveWithSortingDateDesc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer Date DESC")
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string3"
        employer2.integer = 3
        employer2.date = Date().addingTimeInterval(500)
        [employer!, employer2].save {
            EmployerForTesting.retrieve(orderBy: SundeedColumn("date"),
                                        ascending: false,
                                        completion: { (allEmployers) in
                                            XCTAssertEqual(allEmployers.count, 2)
                                            let firstEmployer = allEmployers[0]
                                            let secondEmployer = allEmployers[1]
                                            XCTAssertEqual(firstEmployer.integer, 3)
                                            self.checkEmployer(secondEmployer)
                                            expectation.fulfill()
                                            _ = try? self.employer?.delete()
                                            _ = try? employer2.delete()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testRetrieveWithSortingEnumAsc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer Enum ASC")
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string2"
        employer2.integer = 2
        employer2.type = .ceo
        [employer!, employer2].save {
            EmployerForTesting.retrieve(orderBy: SundeedColumn("type"),
                                        ascending: true,
                                        completion: { (allEmployers) in
                                            XCTAssertEqual(allEmployers.count, 2)
                                            let firstEmployer = allEmployers[0]
                                            let secondEmployer = allEmployers[1]
                                            self.checkEmployer(firstEmployer)
                                            XCTAssertEqual(secondEmployer.integer, 2)
                                            expectation.fulfill()
                                            _ = try? self.employer?.delete()
                                            _ = try? employer2.delete()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testRetrieveWithSortingEnumDesc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer Enum DESC")
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string3"
        employer2.integer = 3
        employer2.type = .ceo
        [employer!, employer2].save {
            EmployerForTesting.retrieve(orderBy: SundeedColumn("type"),
                                        ascending: false,
                                        completion: { (allEmployers) in
                                            XCTAssertEqual(allEmployers.count, 2)
                                            let firstEmployer = allEmployers[0]
                                            let secondEmployer = allEmployers[1]
                                            self.checkEmployer(firstEmployer)
                                            XCTAssertEqual(secondEmployer.integer, 3)
                                            expectation.fulfill()
                                            _ = try? self.employer?.delete()
                                            _ = try? employer2.delete()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testNoPrimaryForClassWithSubclass() {
        let classWithNoPrimaryWithSubClass = ClassWithNoPrimaryWithSubClass()
        classWithNoPrimaryWithSubClass.fillData()
        let expectation = XCTestExpectation(description: "ClassWithNoPrimaryWithSubClass")
        classWithNoPrimaryWithSubClass.save {
            ClassWithNoPrimaryWithSubClass.retrieve(completion: { (results) in
                XCTAssert(results.isEmpty)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testNoPrimaryForClassWithSubclassArray() {
        let classWithNoPrimaryWithSubClassArray = ClassWithNoPrimaryWithSubClassArray()
        classWithNoPrimaryWithSubClassArray.fillData()
        let expectation = XCTestExpectation(description: "ClassWithNoPrimaryWithSubClassArray")
        classWithNoPrimaryWithSubClassArray.save {
            ClassWithNoPrimaryWithSubClassArray.retrieve(completion: { (results) in
                XCTAssert(results.isEmpty)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testNoPrimaryForClassWithImage() {
        let classWithNoPrimaryWithImage = ClassWithNoPrimaryWithImage()
        classWithNoPrimaryWithImage.fillData()
        let expectation = XCTestExpectation(description: "ClassWithNoPrimaryWithImage")
        classWithNoPrimaryWithImage.save {
            ClassWithNoPrimaryWithImage.retrieve(completion: { (results) in
                XCTAssert(results.isEmpty)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testNoPrimaryForClassWithImageArray() {
        let expectation = XCTestExpectation(description: "ClassWithNoPrimaryWithImageArray")
        ClassWithNoPrimaryWithImageArray.delete {
            let classWithNoPrimaryWithImageArray = ClassWithNoPrimaryWithImageArray()
            classWithNoPrimaryWithImageArray.fillData()
            classWithNoPrimaryWithImageArray.save {
                ClassWithNoPrimaryWithImageArray.retrieve(completion: { (results) in
                    XCTAssertEqual(results.count, 1)
                    XCTAssertNil(results.first?.images)
                    expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testNoPrimaryForClassWithPrimitiveArray() {
        let classWithNoPrimaryWithPrimitiveArray = ClassWithNoPrimaryWithPrimitiveArray()
        classWithNoPrimaryWithPrimitiveArray.fillData()
        let expectation = XCTestExpectation(description: "ClassWithNoPrimaryWithPrimitiveArray")
        classWithNoPrimaryWithPrimitiveArray.save {
            ClassWithNoPrimaryWithPrimitiveArray.retrieve(completion: { (results) in
                XCTAssert(results.isEmpty)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testNoPrimaryForClassWithDate() {
        let classWithNoPrimaryWithDate = ClassWithNoPrimaryWithDate()
        classWithNoPrimaryWithDate.fillData()
        let expectation = XCTestExpectation(description: "ClassWithNoPrimaryWithDate")
        classWithNoPrimaryWithDate.save {
            ClassWithNoPrimaryWithDate.retrieve(completion: { (results) in
                XCTAssert(results.isEmpty)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testArraySaving() {
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string1"
        employer2.integer = 2
        let expectation = XCTestExpectation(description: "Array Saving Employer")
        [employer2, employer!].save {
            EmployerForTesting.retrieve(completion: { (allEmployers) in
                guard let employer1 = allEmployers.first else {
                    XCTFail("Couldn't Retrieve From Database")
                    return
                }
                self.checkEmployer(allEmployers[1])
                XCTAssertEqual(employer1.integer, 2)
                XCTAssertEqual(employer1.string, "string1")
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 5)
        
    }
    
    func testUpdateWithNoChanges() {
        do {
            try EmployerForTesting.update()
        } catch {
            guard let sundeedError = error as? SundeedQLiteError else {
                XCTFail("Wrong Error")
                return
            }
            XCTAssertEqual(sundeedError.description, SundeedQLiteError.noChangesMade(tableName: "EmployerForTesting").description)
        }
    }
    
    private func checkEmployer(_ employer: EmployerForTesting) {
        XCTAssertEqual(employer.type, .manager)
        XCTAssertEqual(employer.mandatoryType, .ceo)
        XCTAssertEqual(employer.arrayOfTypes, [.manager, .ceo])
        XCTAssertEqual(employer.optionalArrayOfTypes, [.manager, .ceo])
        XCTAssertEqual(employer.optionalArrayOfOptionalTypes, [.manager, .ceo])
        XCTAssertEqual(employer.arrayOfOptionalTypes, [.manager, .ceo])
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
        XCTAssertEqual(employer.image.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "1")?.jpegData(compressionQuality: 1)?.description)
       
        XCTAssertEqual(employer.optionalImage?.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "2")?.jpegData(compressionQuality: 1)?.description)
        XCTAssertEqual(employer.arrayOfStrings, ["string1", "string2"])
        XCTAssertEqual(employer.arrayOfOptionalStrings, ["string3"])
        XCTAssertEqual(employer.optionalArrayOfStrings, ["string4", "string6"])
        XCTAssertEqual(employer.optionalArrayOfOptionalStrings, ["string7"])
        XCTAssertNotNil(employer.arrayOfObjects)
        XCTAssertFalse(employer.arrayOfObjects.isEmpty)
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
        XCTAssertEqual(employer.arrayOfImages.first?.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "3")?.jpegData(compressionQuality: 1)?.description)
        XCTAssertNotNil(employer.arrayOfOptionalImages)
        
        XCTAssertEqual(employer.arrayOfOptionalImages
            .first??.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "5")?.jpegData(compressionQuality: 1)?.description)
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
