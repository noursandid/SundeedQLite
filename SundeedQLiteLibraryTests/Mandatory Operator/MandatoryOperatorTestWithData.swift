//
//  MandatoryOperatorTestWithData.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation
import XCTest
@testable import SundeedQLiteLibrary

class MandatoryOperatorTestWithData: XCTestCase {
    
    func testClassWithMandatoryOptionalString() {
        let mainClass = ClassWithMandatoryOptionalString()
        mainClass.mandatory = "test"
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalString.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalString.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalInt() {
        let mainClass = ClassWithMandatoryOptionalInt()
        mainClass.mandatory = 0
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalInt.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalInt.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: "2001-07-04T12:08:56.235-0700")
        let mainClass = ClassWithMandatoryOptionalDate()
        mainClass.mandatory = date
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalDate.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.timeIntervalSince1970,
                               date?.timeIntervalSince1970)
                ClassWithMandatoryOptionalDate.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalDouble() {
        let mainClass = ClassWithMandatoryOptionalDouble()
        mainClass.mandatory = 2.0
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalDouble.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalDouble.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalFloat() {
        let mainClass = ClassWithMandatoryOptionalFloat()
        mainClass.mandatory = 3.0
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalFloat.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalFloat.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalImage() {
        let mainClass = ClassWithMandatoryOptionalImage()
        mainClass.mandatory = UIImage(named: "image")
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalImage.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.jpegData(compressionQuality: 0.9),
                               mainClass.mandatory?.jpegData(compressionQuality: 0.9))
                ClassWithMandatoryOptionalImage.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfImages() {
        let mainClass = ClassWithMandatoryOptionalArrayOfImages()
        mainClass.mandatory = [UIImage(named: "image")!]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfImages.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.first?.jpegData(compressionQuality: 0.9),
                               mainClass.mandatory?.first?.jpegData(compressionQuality: 0.9))
                ClassWithMandatoryOptionalArrayOfImages.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalImages() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalImages()
        mainClass.mandatory = [UIImage(named: "image")]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalImages.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.first??.jpegData(compressionQuality: 0.9),
                               mainClass.mandatory?.first??.jpegData(compressionQuality: 0.9))
                ClassWithMandatoryOptionalArrayOfOptionalImages.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfFloats() {
        let mainClass = ClassWithMandatoryOptionalArrayOfFloats()
        mainClass.mandatory = [3.0]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfFloats.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalArrayOfFloats.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalFloats() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalFloats()
        mainClass.mandatory = [3.0]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalFloats.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalArrayOfOptionalFloats.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfDoubles() {
        let mainClass = ClassWithMandatoryOptionalArrayOfDoubles()
        mainClass.mandatory = [3.0]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ClassWithMandatoryOptionalArrayOfDoubles.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalArrayOfDoubles.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalDoubles() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalDoubles()
        mainClass.mandatory = [3.0]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalDoubles.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalArrayOfOptionalDoubles.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfInts() {
        let mainClass = ClassWithMandatoryOptionalArrayOfInts()
        mainClass.mandatory = [3]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfInts.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalArrayOfInts.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalInts() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalInts()
        mainClass.mandatory = [3]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalInts.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalArrayOfOptionalInts.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfStrings() {
        let mainClass = ClassWithMandatoryOptionalArrayOfStrings()
        mainClass.mandatory = ["TTT"]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfStrings.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalArrayOfStrings.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalStrings() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalStrings()
        mainClass.mandatory = ["TTT"]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalStrings.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                ClassWithMandatoryOptionalArrayOfOptionalStrings.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfObjects() {
        let mainClass = ClassWithMandatoryOptionalArrayOfObjects()
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "TTT"
        mainClass.mandatory = [mandatoryClass]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.first?.firstName,
                               mandatoryClass.firstName)
                ClassWithMandatoryOptionalArrayOfObjects.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalObjects() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalObjects()
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "TTT"
        mainClass.mandatory = [mandatoryClass]
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalArrayOfOptionalObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.first??.firstName,
                               mandatoryClass.firstName)
                ClassWithMandatoryOptionalArrayOfOptionalObjects.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalObjects() {
        let mainClass = ClassWithMandatoryOptionalObjects()
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "TTT"
        mainClass.mandatory = mandatoryClass
        mainClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithMandatoryOptionalObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.firstName,
                               mainClass.mandatory?.firstName)
                ClassWithMandatoryOptionalObjects.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
}

