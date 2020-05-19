//
//  MandatoryOperatorTest.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation
import XCTest
@testable import SundeedQLiteLibrary

class MandatoryOperatorTestWithoutData: XCTestCase {
    
    func testClassWithMandatoryOptionalString() {
        let mainClass = ClassWithMandatoryOptionalString()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalString.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalString.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalInt() {
        let mainClass = ClassWithMandatoryOptionalInt()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalInt.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalInt.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalDate() {
        let mainClass = ClassWithMandatoryOptionalDate()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalDate.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalDate.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalDouble() {
        let mainClass = ClassWithMandatoryOptionalDouble()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalDouble.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalDouble.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalFloat() {
        let mainClass = ClassWithMandatoryOptionalFloat()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalFloat.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalFloat.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalImage() {
        let mainClass = ClassWithMandatoryOptionalImage()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalImage.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalImage.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfImages() {
        let mainClass = ClassWithMandatoryOptionalArrayOfImages()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfImages.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfImages.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalImages() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalImages()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalImages.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfOptionalImages.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfFloats() {
        let mainClass = ClassWithMandatoryOptionalArrayOfFloats()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfFloats.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfFloats.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalFloats() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalFloats()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalFloats.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfOptionalFloats.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfDoubles() {
        let mainClass = ClassWithMandatoryOptionalArrayOfDoubles()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfDoubles.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfDoubles.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalDoubles() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalDoubles()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalDoubles.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfOptionalDoubles.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfInts() {
        let mainClass = ClassWithMandatoryOptionalArrayOfInts()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfInts.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfInts.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalInts() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalInts()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalInts.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfOptionalInts.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfStrings() {
        let mainClass = ClassWithMandatoryOptionalArrayOfStrings()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfStrings.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfStrings.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalStrings() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalStrings()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalStrings.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfOptionalStrings.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfObjects() {
        let mainClass = ClassWithMandatoryOptionalArrayOfObjects()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfObjects.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalObjects() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalObjects()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalArrayOfOptionalObjects.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalObjects() {
        let mainClass = ClassWithMandatoryOptionalObjects()
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                ClassWithMandatoryOptionalObjects.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
}
