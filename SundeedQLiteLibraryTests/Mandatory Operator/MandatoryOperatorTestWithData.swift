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
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalString")
        mainClass.save {
            ClassWithMandatoryOptionalString.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalInt() {
        let mainClass = ClassWithMandatoryOptionalInt()
        mainClass.mandatory = 0
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalInt")
        mainClass.save {
            ClassWithMandatoryOptionalInt.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
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
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalDate")
        mainClass.save {
            ClassWithMandatoryOptionalDate.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.timeIntervalSince1970,
                               date?.timeIntervalSince1970)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalDouble() {
        let mainClass = ClassWithMandatoryOptionalDouble()
        mainClass.mandatory = 2.0
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalDouble")
        mainClass.save {
            ClassWithMandatoryOptionalDouble.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalFloat() {
        let mainClass = ClassWithMandatoryOptionalFloat()
        mainClass.mandatory = 3.0
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalFloat")
        mainClass.save {
            ClassWithMandatoryOptionalFloat.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalImage() {
        let mainClass = ClassWithMandatoryOptionalImage()
        mainClass.mandatory = UIImage(named: "image")
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalImage")
        mainClass.save {
            ClassWithMandatoryOptionalImage.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.jpegData(compressionQuality: 0.9),
                               mainClass.mandatory?.jpegData(compressionQuality: 0.9))
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfImages() {
        let mainClass = ClassWithMandatoryOptionalArrayOfImages()
        mainClass.mandatory = [UIImage(named: "image")!]
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfImages")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfImages.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.first?.jpegData(compressionQuality: 0.9),
                               mainClass.mandatory?.first?.jpegData(compressionQuality: 0.9))
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalImages() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalImages()
        mainClass.mandatory = [UIImage(named: "image")]
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalImages")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalImages.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.first??.jpegData(compressionQuality: 0.9),
                               mainClass.mandatory?.first??.jpegData(compressionQuality: 0.9))
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfFloats() {
        let mainClass = ClassWithMandatoryOptionalArrayOfFloats()
        mainClass.mandatory = [3.0]
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfFloats")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfFloats.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalFloats() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalFloats()
        mainClass.mandatory = [3.0]
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalFloats")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalFloats.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfDoubles() {
        let mainClass = ClassWithMandatoryOptionalArrayOfDoubles()
        mainClass.mandatory = [3.0]
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfDoubles")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfDoubles.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalDoubles() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalDoubles()
        mainClass.mandatory = [3.0]
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalDoubles")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalDoubles.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfInts() {
        let mainClass = ClassWithMandatoryOptionalArrayOfInts()
        mainClass.mandatory = [3]
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfInts")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfInts.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalInts() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalInts()
        mainClass.mandatory = [3]
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalInts")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalInts.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfStrings() {
        let mainClass = ClassWithMandatoryOptionalArrayOfStrings()
        mainClass.mandatory = ["TTT"]
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfStrings")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfStrings.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalStrings() {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalStrings()
        mainClass.mandatory = ["TTT"]
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalStrings")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalStrings.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory,
                               mainClass.mandatory)
                _ = try? mainClass.delete()
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
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfObjects")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.first?.firstName,
                               mandatoryClass.firstName)
                _ = try? mainClass.delete()
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
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalArrayOfOptionalObjects")
        mainClass.save {
            ClassWithMandatoryOptionalArrayOfOptionalObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.first??.firstName,
                               mandatoryClass.firstName)
                _ = try? mainClass.delete()
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
        let expectation = XCTestExpectation(description: "ClassWithMandatoryOptionalObjects")
        mainClass.save {
            ClassWithMandatoryOptionalObjects.retrieve(completion: { (retrievedClasses) in
                XCTAssertEqual(retrievedClasses.count, 1)
                XCTAssertEqual(retrievedClasses.first?.mandatory?.firstName,
                               mainClass.mandatory?.firstName)
                _ = try? mainClass.delete()
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2)
    }
}

