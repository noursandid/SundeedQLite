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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryArrayWithEmpty.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryArrayWithEmpty.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithEmpty() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithEmpty()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryOptionalArrayWithEmpty.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryOptionalArrayWithEmpty.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalEmpty() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalEmpty()
        mainClass.mandatoryClasses = []
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryOptionalArrayWithOptionalEmpty.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryOptionalArrayWithOptionalEmpty.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalEmpty() {
        let mainClass = ClassContainingAMandatoryArrayWithOptionalEmpty()
        mainClass.mandatoryClasses = [MandatoryClass()]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryArrayWithOptionalEmpty.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryArrayWithOptionalEmpty.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
}
