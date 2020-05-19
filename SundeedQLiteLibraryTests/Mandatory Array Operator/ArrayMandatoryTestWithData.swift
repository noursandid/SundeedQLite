//
//  ArrayMandatoryTestWithData.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
//@testable import SundeedQLiteLibrary

class ArrayMandatoryTestWithData: XCTestCase {
    
    func testClassContainingAMandatoryClassInOptionalArray() {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryClassInOptionalArray()
        mainClass.mandatoryClasses = [mandatoryClass]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryClassInOptionalArray.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalClassInArray() {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryOptionalClassInArray()
        mainClass.mandatoryClasses = [mandatoryClass]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryArrayWithData
                .retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                    _ = try? mandatoryClass.delete()
                    ClassContainingAMandatoryArrayWithData.delete()
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryOptionalArrayWithData.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                _ = try? mandatoryClass.delete()
                ClassContainingAMandatoryOptionalArrayWithData.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalData() {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalData()
        mainClass.mandatoryClasses = [mandatoryClass]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryOptionalArrayWithOptionalData.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                _ = try? mandatoryClass.delete()
                ClassContainingAMandatoryOptionalArrayWithOptionalData.delete()
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryArrayWithOptionalData
                .retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                    _ = try? mandatoryClass.delete()
                    ClassContainingAMandatoryArrayWithOptionalData.delete()
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryArrayWithData
                .retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                    ClassContainingAMandatoryArrayWithData.delete()
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryOptionalArrayWithData.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                ClassContainingAMandatoryOptionalArrayWithData.delete()
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryOptionalArrayWithOptionalData.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                ClassContainingAMandatoryOptionalArrayWithOptionalData.delete()
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
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingAMandatoryArrayWithOptionalData
                .retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                    ClassContainingAMandatoryArrayWithOptionalData.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassContainingParameterIndex() {
        let mainClass = ClassContainingParameterIndex()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassContainingParameterIndex.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassContainingParameterIndex.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
}
