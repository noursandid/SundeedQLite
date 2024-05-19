//
//  MandatoryOperatorTestWithData.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation
import XCTest
import SundeedQLiteLibrary

class MandatoryOperatorTestWithData: XCTestCase {
    
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
        mainClass.mandatory = "test"
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalString.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalInt() async {
        let mainClass = ClassWithMandatoryOptionalInt()
        mainClass.mandatory = 0
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalInt.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalDate() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: "2001-07-04T12:08:56.235-0700")
        let mainClass = ClassWithMandatoryOptionalDate()
        mainClass.mandatory = date
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalDate.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory?.timeIntervalSince1970,
                       date?.timeIntervalSince1970)
    }
    
    func testClassWithMandatoryOptionalDouble() async {
        let mainClass = ClassWithMandatoryOptionalDouble()
        mainClass.mandatory = 2.0
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalDouble.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalFloat() async {
        let mainClass = ClassWithMandatoryOptionalFloat()
        mainClass.mandatory = 3.0
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalFloat.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalImage() async {
        let mainClass = ClassWithMandatoryOptionalImage()
        mainClass.mandatory = UIImage(named: "1")
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalImage.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory?.jpegData(compressionQuality: 1)?.description,
                       mainClass.mandatory?.jpegData(compressionQuality: 1)?.description)
    }
    
    func testClassWithMandatoryOptionalArrayOfImages() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfImages()
        mainClass.mandatory = [UIImage(named: "2")!]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfImages.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory?.first?.jpegData(compressionQuality: 1)?.description,
                       mainClass.mandatory?.first?.jpegData(compressionQuality: 1)?.description)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalImages() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalImages()
        mainClass.mandatory = [UIImage(named: "3")]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalImages.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory?.first??.jpegData(compressionQuality: 1)?.description,
                       mainClass.mandatory?.first??.jpegData(compressionQuality: 1)?.description)
    }
    
    func testClassWithMandatoryOptionalArrayOfFloats() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfFloats()
        mainClass.mandatory = [3.0]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfFloats.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalFloats() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalFloats()
        mainClass.mandatory = [3.0]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalFloats.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalArrayOfDoubles() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfDoubles()
        mainClass.mandatory = [3.0]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfDoubles.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalDoubles() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalDoubles()
        mainClass.mandatory = [3.0]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalDoubles.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalArrayOfInts() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfInts()
        mainClass.mandatory = [3]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfInts.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalInts() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalInts()
        mainClass.mandatory = [3]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalInts.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalArrayOfStrings() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfStrings()
        mainClass.mandatory = ["TTT"]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfStrings.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalStrings() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalStrings()
        mainClass.mandatory = ["TTT"]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalStrings.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory,
                       mainClass.mandatory)
    }
    
    func testClassWithMandatoryOptionalArrayOfObjects() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfObjects()
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "TTT"
        mainClass.mandatory = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfObjects.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory?.first?.firstName,
                       mandatoryClass.firstName)
    }
    
    func testClassWithMandatoryOptionalArrayOfOptionalObjects() async {
        let mainClass = ClassWithMandatoryOptionalArrayOfOptionalObjects()
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "TTT"
        mainClass.mandatory = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalArrayOfOptionalObjects.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory?.first??.firstName,
                       mandatoryClass.firstName)
    }
    
    func testClassWithMandatoryOptionalObjects() async {
        let mainClass = ClassWithMandatoryOptionalObjects()
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "TTT"
        mainClass.mandatory = mandatoryClass
        
        await mainClass.save()
        let retrievedClasses = await ClassWithMandatoryOptionalObjects.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
        XCTAssertEqual(retrievedClasses.first?.mandatory?.firstName,
                       mainClass.mandatory?.firstName)
    }
}

