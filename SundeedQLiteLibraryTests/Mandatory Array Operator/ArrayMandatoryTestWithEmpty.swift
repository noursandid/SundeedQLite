//
//  ArrayMandatoryTestWithEmpty.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
import SundeedQLiteLibrary

class ArrayMandatoryTestWithEmpty: XCTestCase {
    override func tearDown(completion: @escaping ((any Error)?) -> Void) {
        Task {
            await ClassContainingAMandatoryArrayWithEmpty.delete()
            await ClassContainingAMandatoryOptionalArrayWithEmpty.delete()
            await ClassContainingAMandatoryOptionalArrayWithOptionalEmpty.delete()
            await ClassContainingAMandatoryArrayWithOptionalEmpty.delete()
            completion(nil)
        }
    }
    
    func testClassContainingAMandatoryArrayWithEmpty() async {
        let mainClass = ClassContainingAMandatoryArrayWithEmpty()
        mainClass.mandatoryClasses = [MandatoryClass()]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryArrayWithEmpty.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithEmpty() async {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithEmpty()
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalArrayWithEmpty.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalEmpty() async {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalEmpty()
        mainClass.mandatoryClasses = []
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalArrayWithOptionalEmpty.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalEmpty() async {
        let mainClass = ClassContainingAMandatoryArrayWithOptionalEmpty()
        mainClass.mandatoryClasses = [MandatoryClass()]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryArrayWithOptionalEmpty.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
}
