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
    
    override func tearDown(completion: @escaping ((any Error)?) -> Void) {
        Task {
            await ClassWithMandatoryOptionalString.delete()
            await ClassWithMandatoryOptionalInt.delete()
            await ClassWithMandatoryOptionalDate.delete()
            await ClassWithMandatoryOptionalDouble.delete()
            await ClassWithMandatoryOptionalFloat.delete()
            await ClassWithMandatoryOptionalImage.delete()
            await ClassWithMandatoryOptionalArrayOfImages.delete()
            await ClassWithMandatoryOptionalArrayOfOptionalImages.delete()
            await ClassWithMandatoryOptionalArrayOfFloats.delete()
            await ClassWithMandatoryOptionalArrayOfOptionalFloats.delete()
            await ClassWithMandatoryOptionalArrayOfDoubles.delete()
            await ClassWithMandatoryOptionalArrayOfOptionalDoubles.delete()
            await ClassWithMandatoryOptionalArrayOfInts.delete()
            await ClassWithMandatoryOptionalArrayOfOptionalInts.delete()
            await ClassWithMandatoryOptionalArrayOfStrings.delete()
            await ClassWithMandatoryOptionalArrayOfOptionalStrings.delete()
            await ClassWithMandatoryOptionalArrayOfObjects.delete()
            await ClassWithMandatoryOptionalArrayOfOptionalObjects.delete()
            await ClassWithMandatoryOptionalObjects.delete()
            await MandatoryClass.delete()
            completion(nil)
        }
    }
    
    func testClassWithMandatoryOptionalString() async {
        let mainClass = ClassWithMandatoryOptionalString()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalString.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalInt() async {
        let mainClass = ClassWithMandatoryOptionalInt()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalInt.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalDate() async {
        let mainClass = ClassWithMandatoryOptionalDate()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalDate.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalDouble() async {
        let mainClass = ClassWithMandatoryOptionalDouble()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalDouble.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalFloat() async {
        let mainClass = ClassWithMandatoryOptionalFloat()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalFloat.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalImage() async {
        let mainClass = ClassWithMandatoryOptionalImage()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalImage.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfImages() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfImages()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfImages.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalImages() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalImages()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalImages.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfFloats() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfFloats()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfFloats.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalFloats() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalFloats()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalFloats.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfDoubles() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfDoubles()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfDoubles.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalDoubles() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalDoubles()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalDoubles.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfInts() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfInts()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfInts.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalInts() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalInts()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalInts.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfStrings() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfStrings()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfStrings.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalStrings() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalStrings()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalStrings.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfObjects() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfObjects()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfObjects.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalObjects() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalObjects()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalObjects.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassWithMandatoryOptionalObjects() async {
        let mainClass = ClassWithMandatoryOptionalObjects()
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalObjects.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
}
