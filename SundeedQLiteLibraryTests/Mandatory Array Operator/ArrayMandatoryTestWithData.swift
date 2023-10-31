//
//  ArrayMandatoryTestWithData.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
import SundeedQLiteLibrary

class ArrayMandatoryTestWithData: XCTestCase {
    
    override func tearDown() {
        SundeedQLite.deleteDatabase()
    }
    
    func testClassContainingAMandatoryClassInOptionalArray() {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryClassInOptionalArray()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryClassInOptionalArray")
        mainClass.save {
            ClassContainingAMandatoryClassInOptionalArray.retrieve(completion: { (retrievedClasses) in
                expectation.fulfill()
                XCTAssertEqual(retrievedClasses.count, 0)
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalClassInArray() {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryOptionalClassInArray()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalClassInArray")
        mainClass.save {
            ClassContainingAMandatoryOptionalClassInArray.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalClassInOptionalArray() {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryOptionalClassInOptionalArray()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalClassInOptionalArray")
        mainClass.save {
            ClassContainingAMandatoryOptionalClassInOptionalArray.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryClassInArray() {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryClassInArray()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryClassInArray")
        mainClass.save {
            ClassContainingAMandatoryClassInArray.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryClass() {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryClass()
        mainClass.mandatoryClasses = mandatoryClass
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryClass")
        mainClass.save {
            ClassContainingAMandatoryClass.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalClass() {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryOptionalClass()
        mainClass.mandatoryClasses = mandatoryClass
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalClass")
        mainClass.save {
            ClassContainingAMandatoryOptionalClass.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithData() {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryArrayWithData()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryArrayWithData")
        mainClass.save {
            ClassContainingAMandatoryArrayWithData
                .retrieve(completion: { (retrievedClasses) in
                    XCTAssertEqual(retrievedClasses.count, 1)
                    expectation.fulfill()
                })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithData() {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryOptionalArrayWithData()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalArrayWithData")
        mainClass.save {
            ClassContainingAMandatoryOptionalArrayWithData.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalData() {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalData()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalArrayWithOptionalData")
        mainClass.save {
            ClassContainingAMandatoryOptionalArrayWithOptionalData.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalData() {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryArrayWithOptionalData()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryArrayWithOptionalData")
        mainClass.save {
            ClassContainingAMandatoryArrayWithOptionalData
                .retrieve(completion: { (retrievedClasses) in
                    XCTAssertEqual(retrievedClasses.count, 1)
                    expectation.fulfill()
                })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    
    
    func testClassContainingAMandatoryArrayWithDataWithReference() {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryArrayWithData()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryArrayWithData")
        mainClass.save {
            ClassContainingAMandatoryArrayWithData
                .retrieve(completion: { (retrievedClasses) in
                    XCTAssertEqual(retrievedClasses.count, 1)
                    expectation.fulfill()
                })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithDataWithReference() {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryOptionalArrayWithData()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalArrayWithData")
        mainClass.save {
            ClassContainingAMandatoryOptionalArrayWithData.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalDataWithReference() {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalData()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalArrayWithOptionalData")
        mainClass.save {
            ClassContainingAMandatoryOptionalArrayWithOptionalData.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalDataWithReference() {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryArrayWithOptionalData()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryArrayWithOptionalData")
        mainClass.save {
            ClassContainingAMandatoryArrayWithOptionalData
                .retrieve(completion: { (retrievedClasses) in
                    XCTAssertEqual(retrievedClasses.count, 1)
                    expectation.fulfill()
                })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingParameterIndex() {
        let mainClass = ClassContainingParameterIndex()
        let expectation = XCTestExpectation(description: "ClassContainingParameterIndex")
        mainClass.save {
            ClassContainingParameterIndex.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
}
