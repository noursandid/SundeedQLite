//
//  ArrayMandatoryTestWithNil.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
import SundeedQLiteLibrary

class ArrayMandatoryTestWithNil: XCTestCase {
    override func tearDown() {
        SundeedQLite.deleteDatabase()
    }
    
    func testClassContainingAMandatoryOptionalArrayWithNil() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithNil()
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalArrayWithNil")
        mainClass.save {
            ClassContainingAMandatoryOptionalArrayWithNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithNil() {
        let mainClass = ClassContainingAMandatoryArrayWithNil()
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryArrayWithNil")
        mainClass.save {
            ClassContainingAMandatoryArrayWithNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalNil() {
        let mainClass = ClassContainingAMandatoryArrayWithOptionalNil()
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryArrayWithOptionalNil")
        mainClass.save {
            ClassContainingAMandatoryArrayWithOptionalNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalNil() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalNil()
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalArrayWithOptionalNil")
        mainClass.save {
            ClassContainingAMandatoryOptionalArrayWithOptionalNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithNilSubObject() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithNil()
        let mandatoryClass = MandatoryClass()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalArrayWithNil")
        mainClass.save {
            ClassContainingAMandatoryOptionalArrayWithNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithNilSubObject() {
        let mainClass = ClassContainingAMandatoryArrayWithNil()
        let mandatoryClass = MandatoryClass()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryArrayWithNil")
        mainClass.save {
            ClassContainingAMandatoryArrayWithNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalNilSubObject() {
        let mainClass = ClassContainingAMandatoryArrayWithOptionalNil()
        let mandatoryClass = MandatoryClass()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryArrayWithOptionalNil")
        mainClass.save {
            ClassContainingAMandatoryArrayWithOptionalNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalNilSubObject() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalNil()
        let mandatoryClass = MandatoryClass()
        mainClass.mandatoryClasses = [mandatoryClass]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalArrayWithOptionalNil")
        mainClass.save {
            ClassContainingAMandatoryOptionalArrayWithOptionalNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
}
