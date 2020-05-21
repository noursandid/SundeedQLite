//
//  ArrayMandatoryTestWithEmpty.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest

class ArrayMandatoryTestWithEmpty: XCTestCase {
    func testClassContainingAMandatoryArrayWithEmpty() {
        let mainClass = ClassContainingAMandatoryArrayWithEmpty()
        mainClass.mandatoryClasses = [MandatoryClass()]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryArrayWithEmpty")
        mainClass.save {
            ClassContainingAMandatoryArrayWithEmpty.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
                _ = try? mainClass.delete()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithEmpty() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithEmpty()
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalArrayWithEmpty")
        mainClass.save {
            ClassContainingAMandatoryOptionalArrayWithEmpty.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
                _ = try? mainClass.delete()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalEmpty() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalEmpty()
        mainClass.mandatoryClasses = []
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryOptionalArrayWithOptionalEmpty")
        mainClass.save {
            ClassContainingAMandatoryOptionalArrayWithOptionalEmpty.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
                _ = try? mainClass.delete()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalEmpty() {
        let mainClass = ClassContainingAMandatoryArrayWithOptionalEmpty()
        mainClass.mandatoryClasses = [MandatoryClass()]
        let expectation = XCTestExpectation(description: "ClassContainingAMandatoryArrayWithOptionalEmpty")
        mainClass.save {
            ClassContainingAMandatoryArrayWithOptionalEmpty.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
                _ = try? mainClass.delete()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
}
