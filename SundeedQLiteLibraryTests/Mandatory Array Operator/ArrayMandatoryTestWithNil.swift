//
//  ArrayMandatoryTestWithNil.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest

class ArrayMandatoryTestWithNil: XCTestCase {
    func testClassContainingAMandatoryOptionalArrayWithNil() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithNil()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryOptionalArrayWithNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryOptionalArrayWithNil.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithNil() {
        let mainClass = ClassContainingAMandatoryArrayWithNil()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryArrayWithNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryArrayWithNil.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalNil() {
        let mainClass = ClassContainingAMandatoryArrayWithOptionalNil()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryArrayWithOptionalNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryArrayWithOptionalNil.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalNil() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalNil()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryOptionalArrayWithOptionalNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryOptionalArrayWithOptionalNil.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithNilSubObject() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithNil()
        mainClass.mandatoryClasses = [MandatoryClass()]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryOptionalArrayWithNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryOptionalArrayWithNil.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithNilSubObject() {
        let mainClass = ClassContainingAMandatoryArrayWithNil()
        mainClass.mandatoryClasses = [MandatoryClass()]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryArrayWithNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryArrayWithNil.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalNilSubObject() {
        let mainClass = ClassContainingAMandatoryArrayWithOptionalNil()
        mainClass.mandatoryClasses = [MandatoryClass()]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryArrayWithOptionalNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryArrayWithOptionalNil.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalNilSubObject() {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalNil()
        mainClass.mandatoryClasses = [MandatoryClass()]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryOptionalArrayWithOptionalNil.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingAMandatoryOptionalArrayWithOptionalNil.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
}
