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
    
    override func tearDown() {
        SundeedQLite.deleteDatabase()
    }
    
    func testClassWithMandatoryOptionalString() {
        let mainClass = ClassWithMandatoryOptionalString()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalString")
        mainClass.save {
            ClassWithMandatoryOptionalString.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalInt() {
        let mainClass = ClassWithMandatoryOptionalInt()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalInt")
        mainClass.save {
            ClassWithMandatoryOptionalInt.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalDate() {
        let mainClass = ClassWithMandatoryOptionalDate()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalDate")
        mainClass.save {
            ClassWithMandatoryOptionalDate.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalDouble() {
        let mainClass = ClassWithMandatoryOptionalDouble()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalDouble")
        mainClass.save {
            ClassWithMandatoryOptionalDouble.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalFloat() {
        let mainClass = ClassWithMandatoryOptionalFloat()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalFloat")
        mainClass.save {
            ClassWithMandatoryOptionalFloat.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalImage() {
        let mainClass = ClassWithMandatoryOptionalImage()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalImage")
        mainClass.save {
            ClassWithMandatoryOptionalImage.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfImages() {
        let mainClass = ClassWithMandatoryOptionalArrayOfImages()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfImages")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfImages.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalImages() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalImages()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalImages")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalImages.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfFloats() {
        let mainClass = ClassWithMandatoryOptionalArrayOfFloats()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfFloats")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfFloats.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalFloats() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalFloats()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalFloats")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalFloats.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfDoubles() {
        let mainClass = ClassWithMandatoryOptionalArrayOfDoubles()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfDoubles")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfDoubles.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalDoubles() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalDoubles()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalDoubles")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalDoubles.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfInts() {
        let mainClass = ClassWithMandatoryOptionalArrayOfInts()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfInts")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfInts.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalInts() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalInts()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalInts")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalInts.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfStrings() {
        let mainClass = ClassWithMandatoryOptionalArrayOfStrings()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfStrings")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfStrings.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalStrings() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalStrings()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalStrings")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalStrings.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfObjects() {
        let mainClass = ClassWithMandatoryOptionalArrayOfObjects()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfObjects")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalObjects() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalObjects()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalObjects")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalObjects() {
        let mainClass = ClassWithMandatoryOptionalObjects()
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalObjects")
        mainClass.save {
            ClassWithMandatoryOptionalObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 0)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
}
